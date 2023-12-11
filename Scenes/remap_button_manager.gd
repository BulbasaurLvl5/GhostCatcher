class_name RemapButtonManager
extends Node


@export var input_name_substitutions : Array[String]

var is_remapping_button : bool
var remap_buttons : Array[RemapButton]


func _ready():
	is_remapping_button = false
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
	@warning_ignore("unassigned_variable")
	var array : Array[InputEvent]
	for button in remap_buttons:
		var event = InputMap.action_get_events(button.action)[button.event_index]
		array.append(event)
	return array
		

func restore_input_events_from_save(array : Array[InputEvent]):
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
	InputMap.load_from_project_settings()
	update_buttons()
