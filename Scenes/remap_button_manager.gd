class_name RemapButtonManager
extends Node


var is_remapping_button : bool
var remap_buttons : Array[RemapButton]
var input_name_substitutions : Array[String]


func _ready():
	is_remapping_button = false
	get_event_name_array()
	var menu_items : Array[Node]
	menu_items = $"..".get_children()
	for item in menu_items:
		if item is RemapButton:
			remap_buttons.append(item)
	update_buttons()
	
	
func update_buttons():
	for item in remap_buttons:
		item.update_button()
		

func get_input_events_for_saving() -> Array[InputEvent]:
	#TO SAVE REMAPPED INPUTS, CALL THIS METHOD FROM ANOTHER CLASS AND SAVE THE ARRAY TO DISK
	#TO SAVE REMAPPED INPUTS, CALL THIS METHOD FROM ANOTHER CLASS AND SAVE THE ARRAY TO DISK
	#TO SAVE REMAPPED INPUTS, CALL THIS METHOD FROM ANOTHER CLASS AND SAVE THE ARRAY TO DISK
	var array : Array[InputEvent]
	for button in remap_buttons:
		var event = InputMap.action_get_events(button.action)[button.event_index]
		array.append(event)
	return array
		

func restore_input_events_from_save(array : Array[InputEvent]):
	#CALL THIS METHOD WHEN STARTING THE GAME TO RESTORE REMAPPED INPUT EVENTS FROM SAVE FILE
	#CALL THIS METHOD WHEN STARTING THE GAME TO RESTORE REMAPPED INPUT EVENTS FROM SAVE FILE
	#CALL THIS METHOD WHEN STARTING THE GAME TO RESTORE REMAPPED INPUT EVENTS FROM SAVE FILE
	if array.size() == remap_buttons.size():
		var count : int = 0
		for button in remap_buttons:
			change_input_event(button.action, button.event_index, array[count])
			count += 1
	else:
		print("Could not restore input settings. Incorrect number of items in saved array.")		
			
			
func change_input_event(action : String, event_index : int, event : InputEvent):
	var events = InputMap.action_get_events(action)
	InputMap.action_erase_events(action)
	events.remove_at(event_index)
	events.insert(event_index, event)
	for e in events:
		InputMap.action_add_event(action, e)
		

func reset_to_defaults():
	#CALL THIS METHOD TO RESET THE INPUTS TO THE GAME DEFAULT
	#CALL THIS METHOD TO RESET THE INPUTS TO THE GAME DEFAULT
	#CALL THIS METHOD TO RESET THE INPUTS TO THE GAME DEFAULT
	InputMap.load_from_project_settings()
	update_buttons()


func get_event_name_array():
	input_name_substitutions.clear()
	input_name_substitutions += ["Joypad Button 0 ", "Bottom Action",
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
		"Joypad Motion on Axis 0 (Left Stick X-Axis, Joystick 0 X-Axis) with Value 1", "LS Right"]
