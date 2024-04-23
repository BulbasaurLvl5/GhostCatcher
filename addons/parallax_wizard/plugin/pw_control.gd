@tool
class_name ParallaxWizardControl
extends Control

#TODO: all this export info should be saved as a json or something and not be stored here
#@export var custom_scene_category_names : Array[String]
#@export var custom_scenes : Array[Array]
#@export var custom_scene_names : Array[Array]

var pw
var current_menu_items : Array
var scroll_locked : bool = false:
	set(value):
		if scroll_locked == value:
			return
		scroll_locked = value
		pw.scroll_locked = value
		scroll_lock_sliders = Vector2.ZERO
		%VSlider_Scroll.editable = value
		%HSlider_Scroll.editable = value
		%TextureRect_Crosshairs.self_modulate.a = int(value)
		%VSlider_Scroll.value = float(value) - 1.0
		%HSlider_Scroll.value = float(value) - 1.0
		var color : Color
		if value:
			color = Color.CRIMSON
		else:
			color = Color.DIM_GRAY
		%VSlider_Scroll.self_modulate = color
		%HSlider_Scroll.self_modulate = color
var scroll_lock_sliders : Vector2 = Vector2.ZERO:
	set(value):
		if scroll_lock_sliders == value || !scroll_locked:
			return
		scroll_lock_sliders = value
		if scroll_lock_shifting:
			pw.update_scroll_lock_target(scroll_lock_sliders * Vector2(1.0, -1.0))
		else:
			%VSlider_Scroll.value = scroll_lock_sliders.y
			%HSlider_Scroll.value = scroll_lock_sliders.x
var scroll_lock_shifting : bool = false:
	set(value):
		if scroll_lock_shifting == value:
			return
		scroll_lock_shifting = value
var color_tool_open : bool = false:
	set(value):
		color_tool_open = value
		%ColorTool.visible = color_tool_open
var layer_count : int:
	set(value):
		layer_count = value
		%LayerCount.text = str(value)
		if value == 1:
			%Label_LayerCount.text = "ParallaxPlus Layer"
		else:
			%Label_LayerCount.text = "ParallaxPlus Layers"
		distance_available()
var canvas_item_count : int:
	set(value):
		canvas_item_count = value
		%CanvasItemCount.text = str(value)
		if value == 1:
			%Label_CanvasItems.text = "CanvasItem"
			%Button_ModeColorCurrentNode.disabled = false
		else:
			%Label_CanvasItems.text = "CanvasItems"
			%Button_ModeColorCurrentNode.disabled = true
		if value > 0:
			color_available(true)
		else:
			color_available(false)


func set_up(pw_instance : Node):
	pw = pw_instance

	if current_menu_items:
		current_menu_items.clear()
	var children = %HBox_Custom_Menus.get_children(true)
	for c in children:
		c.queue_free()
	
#	#TODO: Here is where I will load the buttons when the data is on JSON
	var menu_count = 0
	var total_item_count = 0
	
	for n in pw.custom_cat_names:
		var b = add_custom_button("  " + n + "  ")
		var p = b.get_popup()
		var menu_items = pw.custom_items[menu_count]
		var item_count = 0
		for i in menu_items:
			if i is PackedScene:
				p.add_item(pw.custom_item_names[menu_count][item_count], total_item_count)
				current_menu_items.append(i)
				item_count += 1
				total_item_count += 1
		#p.add_item("[add existing]", total_item_count)
		#current_menu_items.append(menu_count * 2)
		#total_item_count += 1
		#p.add_item("[create new]", total_item_count)
		#current_menu_items.append(menu_count * 2 + 1)
		#total_item_count += 1
		p.id_pressed.connect(_on_button_custom_item_chosen)
		menu_count += 1
		
	while menu_count < 10:
		var b = add_custom_button("  CUSTOM " + str(menu_count + 1) + "  ")
		b.disabled = true
		menu_count += 1
	


func add_custom_button(text : String) -> MenuButton:
	var b = MenuButton.new()
	%HBox_Custom_Menus.add_child(b)
	b.text = text
	b.theme = %HBox_Custom_Menus.theme
	b.flat = false
	#print(%HBox_Custom_Menus.theme, b.theme)
	#if button_theme:
		#b.theme = button_theme
	return b
	

func distance_available():
	if layer_count > 0:
		%Slider_Distance.editable = true
		%OptionButton_ModeDistance.disabled = false
		if %SpinBox_ModeDistance.visible:
			%SpinBox_ModeDistance.editable = true
	else:
		%Slider_Distance.editable = false
		%OptionButton_ModeDistance.disabled = true
		%SpinBox_ModeDistance.editable = false


func color_available(available : bool = true):
	if available:
		%Slider_Color.editable = true
		%OptionButton_Edit.disabled = false
		%OptionButton_Parameter.disabled = false
		%OptionButton_ModeColor.disabled = false
		if %SpinBox_ModeColor.visible:
			%SpinBox_ModeColor.editable = true
	else:
		%Slider_Color.editable = false
		%OptionButton_Edit.disabled = true
		%OptionButton_Parameter.disabled = true
		%OptionButton_ModeColor.disabled = true
		%SpinBox_ModeColor.editable = false


#SIGNAL METHODS
func _on_distance_hover_entered():
	if pw.selected_layers:
		pw.selection_mode = pw.SelectionModes.DISTANCE
		
func _on_color_hover_entered():
	if pw.selected_canvas_items:
		pw.selection_mode = pw.SelectionModes.COLOR	
		
func _on_hover_exited():
	pw.selection_mode = pw.SelectionModes.DEFAULT


#DISTANCE TOOL SIGNAL METHODS
func _on_slider_distance_drag_started():
	pw.start_distance_shift(%OptionButton_ModeDistance.selected, %SpinBox_ModeDistance.value)

func _on_slider_distance_value_changed(value):
	pw.shift_distance(value)

func _on_slider_distance_drag_ended(value_changed):
	pw.shifting_distance = false
	%Slider_Distance.value = 0.0

func _on_option_button_mode_distance_item_selected(index):
	if index == pw.DistanceModes.OTHER:
		%OptionButton_ModeDistance.set_item_text(3, "Relative to")
		%SpinBox_ModeDistance.visible = true
		%Button_ModeDistanceCurrentBG.visible = true
		%Label_MinDistance.text = "Together"
		%Label_MaxDistance.text = "Apart"
	else:
		%OptionButton_ModeDistance.set_item_text(3, "Relative to Custom Value")
		%SpinBox_ModeDistance.visible = false
		if index == pw.DistanceModes.DEFAULT:
			%Label_MinDistance.text = "Together"
			%Label_MaxDistance.text = "Apart"
		else:
			%Label_MinDistance.text = "Min"
			%Label_MaxDistance.text = "Max"

func _on_button_mode_distance_current_bg_pressed():
	var value = clamp(pw.selected_layers[0].distance, -1.0, 1.0)
	%SpinBox_ModeDistance.value = value


#MAIN TOOL SIGNAL METHODS
func _on_button_custom_item_chosen(id : int):
	var item = current_menu_items[id]
	if item is PackedScene:
		pw.add_custom_item(item)
	#elif item is int:
		#if (float(item) / 2.0) == int(float(item) / 2.0):
			#add_existing_scene_to_custom(item / 2)
		#else:
			#create_new_scene_for_custom(item - 1 / 2)
			
func _on_button_settings_pressed():
	pw.open_settings()

func _on_button_convert_pressed():
	pw.convert_scene()
	pw.refresh_scene()

func _on_button_edit_custom_pressed():
	pw.open_custom_edit_menu()

func _on_check_box_scroll_lock_toggled(value):
	scroll_locked = value

func _on_scroll_lock_drag_started():
	scroll_lock_shifting = true

func _on_scroll_lock_drag_ended(_value_changed):
	scroll_lock_shifting = false

func _on_v_slider_scroll_value_changed(value):
	if scroll_lock_shifting:
		scroll_lock_sliders = Vector2(scroll_lock_sliders.x, value)
		
func _on_h_slider_scroll_value_changed(value):
	if scroll_lock_shifting:
		scroll_lock_sliders = Vector2(value, scroll_lock_sliders.y)

func _on_menu_button_add_layer_about_to_popup():
	if !%MenuButton_AddLayer.get_popup().index_pressed.is_connected(_on_menu_button_add_layer_selected):
		%MenuButton_AddLayer.get_popup().index_pressed.connect(_on_menu_button_add_layer_selected)

func _on_menu_button_add_layer_selected(index : int):
	pw.add_new_layer(index)


#COLOR TOOL SIGNAL METHODS
func _on_check_box_color_tool_toggled(toggled_on):
	color_tool_open = toggled_on

func _on_slider_color_drag_started():
	pw.start_color_shift(%OptionButton_Parameter.selected, %OptionButton_ModeColor.selected, %SpinBox_ModeColor.value)
	
func _on_slider_color_value_changed(value):
	pw.shift_color(value)

func _on_slider_color_drag_ended(value_changed):
	pw.shifting_color = false
	%Slider_Color.value = 0.5
	
func _on_option_button_edit_item_selected(index):
	if index == 0:
		%Label_Modulate.text = "MOD"
		pw.color_edit_type = pw.ColorEditTypes.MODULATE
	else:
		%Label_Modulate.text = "SELF-MOD"
		pw.color_edit_type = pw.ColorEditTypes.SELF_MODULATE

func _on_option_button_parameter_item_selected(index):
	%Label_Parameter.text = str(pw.ColorParameters.keys()[index]) 

func _on_option_button_mode_color_item_selected(index):
	if index == pw.ColorModes.OTHER:
		%OptionButton_ModeColor.set_item_text(2, "Relative to")
		%SpinBox_ModeColor.visible = true
		%SpinBox_ModeColor.editable = true
		%Label_MinColor.text = "Together"
		%Label_MaxColor.text = "Apart"
	else:
		%OptionButton_ModeColor.set_item_text(2, "Relative to Custom Value")
		%SpinBox_ModeColor.visible = false
		%SpinBox_ModeColor.editable = false
		%Label_MinColor.text = "Min"
		%Label_MaxColor.text = "Max"		

func _on_button_mode_color_current_node_pressed():
	var node = pw.selected_canvas_items[0]
	var color : Color
	var value : float
	if %OptionButton_Edit.selected == pw.ColorEditTypes.MODULATE:
		color = node.modulate
	else:
		color = node.self_modulate
	if %OptionButton_Parameter.selected == pw.ColorParameters.HUE:
		value = color.h
	elif %OptionButton_Parameter.selected == pw.ColorParameters.SATURATION:
		value = pw.get_saturation_value(color)
	elif %OptionButton_Parameter.selected == pw.ColorParameters.LIGHTNESS:
		value = pw.get_lightness_value(color)
	elif %OptionButton_Parameter.selected == pw.ColorParameters.ALPHA:
		value = color.a
	elif %OptionButton_Parameter.selected == pw.ColorParameters.RED:
		value = color.r
	elif %OptionButton_Parameter.selected == pw.ColorParameters.GREEN:
		value = color.g
	elif %OptionButton_Parameter.selected == pw.ColorParameters.BLUE:
		value = color.b	
	%SpinBox_ModeDistance.value = value

func _on_h_slider_scroll_drag_ended(value_changed):
	pass # Replace with function body.
