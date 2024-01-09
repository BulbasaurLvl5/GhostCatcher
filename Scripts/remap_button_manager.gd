class_name RemapButtonManager
extends Node


var is_remapping_button : bool
var remap_buttons : Array[RemapButton]
var input_name_substitutions : Array[String]

var save_dir : String = "user://"
var file_name : String = "CustomInputs.json"
var security_key : String = "this_part_is_useless_actually_5678h5r675r6756r756"


func _ready():
	is_remapping_button = false
	get_event_name_array()
	var menu_items : Array[Node]
	menu_items = $"..".get_children()
	for i in menu_items:
		if i is RemapButton:
			remap_buttons.append(i)
	restore_input_events_from_save()
	update_buttons()
	

func _exit_tree():
	save_input_events_to_disk()
	
	
func update_buttons():
	for b in remap_buttons:
		b.update_button()
		

func save_input_events_to_disk():
	var type_array : Array = []
	var id_array : Array = []
	for b in remap_buttons:
		var actions = b.actions
		var event_indexes = b.event_indexes
		var count = 0
		for a in actions:
			var event = InputMap.action_get_events(a)[event_indexes[count]]
			if event is InputEventKey:
				type_array.append("Key")
				id_array.append(event.keycode)
			elif event is InputEventJoypadButton:
				type_array.append("JoypadButton")
				id_array.append(event.button_index)
			elif event is InputEventJoypadMotion:
				type_array.append("JoypadMotion")
				id_array.append((event.axis + 1) * event.axis_value)
			else:
				type_array.append("Null")
				id_array.append("Null")
				print("Custom input entry is null")
			count += 1

	var file = FileAccess.open_encrypted_with_pass(save_dir + file_name, FileAccess.WRITE, security_key)
	if file == null:
		print(FileAccess.get_open_error())
		return
	
	var data = {
		"custom_inputs":{
			"type_data" : type_array,
			"id_data" : id_array	
		}
	}

	var json_string = JSON.stringify(data, "\t")
	file.store_string(json_string)
	file.close()
	print("saved custom inputs to: ",save_dir + file_name)


func restore_input_events_from_save():
	if FileAccess.file_exists(save_dir + file_name):
		var file = FileAccess.open_encrypted_with_pass(save_dir + file_name, FileAccess.READ, security_key)
		if file == null:
			print(FileAccess.get_open_error())
			return	
			
		var content = file.get_as_text()
		file.close()
		
		var data = JSON.parse_string(content)
		if data == null:
			printerr("Cannot parse %s as a json_string: (%s)" % [save_dir + file_name, content])
			return

		var type_array = data.custom_inputs.type_data
		var id_array = data.custom_inputs.id_data

		if type_array.size() == remap_buttons.size():
			var index : int = 0
			for b in remap_buttons:
				var actions = b.actions
				var event_indexes = b.event_indexes
				var count = 0
				for a in actions:
					var event
					if type_array[index] == "Key":
						event = InputEventKey.new()
						event.set_keycode(id_array[index])	
					elif type_array[index] == "JoypadButton":
						event = InputEventJoypadButton.new()
						event.set_button_index(id_array[index])
					elif type_array[index] == "JoypadMotion":
						event = InputEventJoypadMotion.new()
						event.set_axis(abs(id_array[index])-1)
						if id_array[index] > 0:
							event.set_axis_value(1)
						else:
							event.set_axis_value(-1)
					else:
						print(b," custom input could not be retrieved")
					change_input_event(a, event_indexes[count], event)
					index += 1
					count += 1
			print("restored custom inputs from: ",save_dir + file_name)
		else:
			print("Could not restore input settings. Incorrect number of items in saved array.")
		update_buttons()

	else:
		printerr("Cannot open non-existent file at %s!" % [save_dir + file_name])

			
func change_input_event(action : String, event_index : int, event : InputEvent):
	var events = InputMap.action_get_events(action)
	InputMap.action_erase_events(action)
	events.remove_at(event_index)
	events.insert(event_index, event)
	for e in events:
		InputMap.action_add_event(action, e)
		

func _on_reset_button_pressed():
	InputMap.load_from_project_settings()
	update_buttons()


func get_event_name_array():
	input_name_substitutions.clear()
	input_name_substitutions += [
		"Joypad Button 0 ", "Bottom Action",
		"Joypad Button 1 ", "Right Action",
		"Joypad Button 2 ", "Left Action",
		"Joypad Button 3 ", "Top Action",
		"Joypad Button 4 ", "Back",
		"Joypad Button 5 ", "Guide",
		"Joypad Button 6 ", "Start",
		"Joypad Button 7 ", "LS Push",
		"Joypad Button 8 ", "RS Push",
		"Joypad Button 9 ", "L Shoulder",
		"Joypad Button 10 ", "R Shoulder",
		"Joypad Button 11 ", "D Up",
		"Joypad Button 12 ", "D Down",
		"Joypad Button 13 ", "D Left",
		"Joypad Button 14 ", "D Right",
		"Joypad Button 15 ", "Share",
		"Joypad Button 16 ", "Paddle 1",
		"Joypad Button 17 ", "Paddle 2",
		"Joypad Button 18 ", "Paddle 3",
		"Joypad Button 19 ","Paddle 4",
		"Joypad Button 20 ", "Pad",
		"Joypad Axis 0 - ", "LS Left",
		"Joypad Axis 0 + ", "LS Right",
		"Joypad Axis 1 - ", "LS Up",
		"Joypad Axis 1 + ", "LS Down",
		"Joypad Axis 2 - ", "RS Left",
		"Joypad Axis 2 + ", "RS Right",
		"Joypad Axis 3 - ", "RS Up",
		"Joypad Axis 3 + ", "RS Down",
		"Joypad Axis 4 + ", "L Trigger",
		"Joypad Axis 5 + ", "R Trigger",
		"Joypad Motion on Axis 3 (Right Stick Y-Axis, Joystick 1 Y-Axis) with Value -1", "RS Up",
		"Joypad Motion on Axis 3 (Right Stick Y-Axis, Joystick 1 Y-Axis) with Value 1", "RS Down",
		"Joypad Motion on Axis 2 (Right Stick X-Axis, Joystick 1 X-Axis) with Value -1", "RS Left",
		"Joypad Motion on Axis 2 (Right Stick X-Axis, Joystick 1 X-Axis) with Value 1", "RS Right",
		"Joypad Motion on Axis 1 (Left Stick Y-Axis, Joystick 0 Y-Axis) with Value -1", "LS Up",
		"Joypad Motion on Axis 1 (Left Stick Y-Axis, Joystick 0 Y-Axis) with Value 1", "LS Down",
		"Joypad Motion on Axis 0 (Left Stick X-Axis, Joystick 0 X-Axis) with Value -1", "LS Left",
		"Joypad Motion on Axis 0 (Left Stick X-Axis, Joystick 0 X-Axis) with Value 1", "LS Right"
		]
