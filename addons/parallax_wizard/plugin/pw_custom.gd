@tool
class_name ParallaxWizardCustom
extends Panel


const cat_buttons_preload = preload("res://addons/parallax_wizard/plugin/pw_category_buttons.tscn")
const item_buttons_preload = preload("res://addons/parallax_wizard/plugin/pw_item_buttons.tscn")

var pw
var current_cat : int
var selected_item : int
var last_item_name : LineEdit
var single_node : Node:
	set(value):
		if value:
			%Button_CreateItem.disabled = false
		else:
			%Button_CreateItem.disabled = true
		single_node = value


func set_up(pw_instance : Node):
	pw = pw_instance
	show_cats(true)
	show_items(false)
	grab_focus()


func show_cats(active : bool):
	if active:
		refresh_cats()
	%Label_CatTitle.visible = active
	%Grid_Categories.visible = active
	%Button_AddCat.visible = active

func refresh_cats():
	var children = %Grid_Categories.get_children()
	for child in children:
		if !child is Label:
			child.queue_free()

	var count : int = 0
	for cat in pw.custom_cat_names:
		var new = cat_buttons_preload.instantiate()
		var buttons = get_children(new)
		for b in buttons:
			%Grid_Categories.add_child(b)
		new.queue_free()
		buttons[0].pressed.connect(reorder_cats.bind(count, -1))
		buttons[1].pressed.connect(reorder_cats.bind(count, 1))
		buttons[2].text = cat
		buttons[2].text_submitted.connect(rename_cat.bind(count))
		buttons[3].pressed.connect(edit_cat.bind(count))
		buttons[4].pressed.connect(delete_cat.bind(count))
		count += 1

func reorder_cats(index : int, direction : int):
	if abs(direction) != 1:
		return
	if index + direction > pw.custom_categories.size() - 1:
		return
	if index + direction < 0:
		return
	var data
	data = pw.custom_categories.pop_at(index)
	pw.custom_categories.insert(index + direction, data)
	data = pw.custom_items.pop_at(index)
	pw.custom_items.insert(index + direction, data)
	data = pw.custom_item_names.pop_at(index)
	pw.custom_item_names.insert(index + direction, data)
	refresh_cats()

func rename_cat(new_text : String, index : int):
	pw.custom_categories.remove_at(index)
	pw.custom_categories.insert(index, new_text)

func edit_cat(index : int):
	current_cat = index
	show_cats(false)
	show_items(true)

func delete_cat(index : int):
	pw.custom_categories.remove_at(index)
	pw.custom_items.remove_at(index)
	pw.custom_item_names.remove_at(index)
	refresh_cats()

func show_items(active : bool):
	if active:
		refresh_items()
	%VBox_ItemsTitle.visible = active
	%Grid_Items.visible = active
	%VBox_AddItems.visible = active

func refresh_items():
	%LineEdit_CatName.text = pw.custom_categories[current_cat]
	var children = %Grid_Items.get_children()
	for child in children:
		if !child is Label:
			child.queue_free()
			
	if !pw.custom_items[current_cat] is Array:
		return
		
	var count : int = 0
	for item in pw.custom_items[current_cat]:
		var new = item_buttons_preload.instantiate()
		var buttons = get_children(new)
		for b in buttons:
			%Grid_Items.add_child(b)
		new.queue_free()
		buttons[0].pressed.connect(reorder_items.bind(count, -1))
		buttons[1].pressed.connect(reorder_items.bind(count, 1))
		buttons[2].text = pw.custom_item_names[current_cat][count]
		buttons[2].text_submitted.connect(rename_item.bind(count))
		last_item_name = buttons[2]
		buttons[3].text = item.name
		buttons[3].pressed.connect(change_item.bind(count))
		buttons[4].pressed.connect(remove_item.bind(count))
		count += 1

func reorder_items(index : int, direction : int):
	if abs(direction) != 1:
		return
	if index + direction > pw.custom_items[current_cat].size() - 1:
		return
	if index + direction < 0:
		return
	var data
	data = pw.custom_items[current_cat].pop_at(index)
	pw.custom_items[current_cat].insert(index + direction, data)
	data = pw.custom_item_names[current_cat].pop_at(index)
	pw.custom_item_names[current_cat].insert(index + direction, data)
	refresh_items()
	
func rename_item(new_text : String, index : int):
	pw.custom_item_names[current_cat].remove_at(index)
	pw.custom_item_names[current_cat].insert(index, new_text)

func change_item(index : int):
	selected_item = index
	var dialog = EditorFileDialog.new()
	add_child(dialog)
	dialog.file_mode = EditorFileDialog.FILE_MODE_OPEN_FILE
	dialog.add_filter("*.tscn", "PackedScene")
	dialog.mode_overrides_title = false
	dialog.title = "Select replacement file"
	if pw.custom_items[current_cat][index].is_absolute_path():
		dialog.set_current_path(pw.custom_items[current_cat][index])
		dialog.set_current_file(pw.custom_items[current_cat][index])
	dialog.file_selected.connect(_on_file_dialog_change_file_selected)
	dialog.grab_focus()
	
func _on_file_dialog_change_file_selected(path):
	pw.custom_items[current_cat].remove_at(selected_item)
	pw.custom_items[current_cat].insert(selected_item, path)
	refresh_items()

func remove_item(index : int):
	pw.custom_items[current_cat].remove_at(index)
	pw.custom_item_names[current_cat].remove_at(index)
	refresh_items()

func add_item(path : String):
	var item_name = path.get_file()
	var suffix = item_name.find(".tscn")
	if suffix > 0:
		item_name.erase(suffix, 5)
	pw.custom_items[current_cat].append(path)
	pw.custom_item_names[current_cat].append(item_name)


func _on_line_edit_cat_name_text_submitted(new_text):
	pw.custom_categories.remove_at(current_cat)
	pw.custom_categories.insert(current_cat, new_text)

func _on_button_add_cat_pressed():
	var new_name : String = "CUSTOM_"
	if pw.custom_categories.size() < 9:
		new_name += "0"
	new_name += str(pw.custom_categories.size() + 1)
	pw.custom_categories.append(new_name)
	pw.custom_items.append([])
	pw.custom_item_names.append([])
	current_cat = pw.custom_categories.size() - 1
	show_cats(false)
	show_items(true)
	%LineEdit_CatName.select_all()
	%LineEdit_CatName.grab_focus()
	
func _on_button_add_items_pressed():
	var dialog = EditorFileDialog.new()
	add_child(dialog)
	dialog.file_mode = EditorFileDialog.FILE_MODE_OPEN_FILES
	dialog.add_filter("*.tscn", "PackedScene")
	dialog.mode_overrides_title = false
	dialog.title = "Select files to add"
	dialog.files_selected.connect(_on_file_dialog_add_files_selected)
	dialog.grab_focus()
	
func _on_file_dialog_add_files_selected(paths):
	for p in paths:
		add_item(p)
	refresh_items()
	last_item_name.select_all()
	last_item_name.grab_focus()

func _on_button_create_item_pressed():
	var dialog = EditorFileDialog.new()
	add_child(dialog)
	dialog.file_mode = EditorFileDialog.FILE_MODE_SAVE_FILE
	dialog.add_filter("*.tscn", "PackedScene")
	dialog.current_dir = "res://addons/parallax_wizard/custom/"
	dialog.current_file = single_node.name + ".tscn"
	dialog.mode_overrides_title = false
	dialog.title = "Save file"
	dialog.file_selected.connect(_on_file_dialog_save_file_selected)
	dialog.grab_focus()

func _on_file_dialog_save_file_selected(path):
	var scene = PackedScene.new()
	var result = scene.pack(single_node)
	if result == OK:
		var error = ResourceSaver.save(scene, path)
		if error == OK:
			add_item(path)
			refresh_items()
			last_item_name.select_all()
			last_item_name.grab_focus()
		else:
			push_error("An error occurred while saving the scene to disk.")

func _on_button_exit_button_down():
	queue_free()
