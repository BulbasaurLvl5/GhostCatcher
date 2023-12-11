class_name RemapButton
extends Button


@export var action : String
@export var event_index : int

var remap_button_manager : RemapButtonManager


func _ready():
	var menu_items : Array[Node]
	menu_items = $"..".get_children()
	for item in menu_items:
		if item is RemapButtonManager:
			remap_button_manager = item


func update_button():
	set_process_unhandled_input(false)
	var event_name : String = "%s" % InputMap.action_get_events(action)[event_index].as_text()
	var count : int = 0
	var name_was_shortened : bool = false
	for string in remap_button_manager.input_name_substitutions:
		if event_name.begins_with(string) && count < remap_button_manager.input_name_substitutions.size()-1:
			event_name = remap_button_manager.input_name_substitutions[count+1]
			name_was_shortened = true
			break
		count += 1
	if !name_was_shortened && event_name.length() > 12:
		print(event_name," needs to be added to the input name-shortening database")
	text = event_name


func _process(_delta):
	if button_pressed:
		if !%RemapButtonManager.is_remapping_button:
			%RemapButtonManager.is_remapping_button = true
			text = "..."
			release_focus()
			set_process_unhandled_input(true)
		else:
			release_focus()


func _unhandled_input(event):
	if event is InputEventKey || event is InputEventJoypadButton:
		check_input(event)
		return
	if event is InputEventJoypadMotion:
		if event.get_axis_value() > 0.5:
			event.set_axis_value(1)
			check_input(event)
		if event.get_axis_value() < -0.5:
			event.set_axis_value(-1)
			check_input(event)
	
	
func check_input(event):	
	set_process_unhandled_input(false)
	var action_is_available : bool = true
	var actions = InputMap.get_actions()
	for a in actions:
		if !a.begins_with("ui"):
			var events = InputMap.action_get_events(a)
			for e in events:
				if e == event:
					action_is_available = false
					if e is InputEventJoypadMotion:
						if event.get_axis_value() != e.get_axis_value():
							action_is_available = true
	if action_is_available:
		change_input_event(event)
	else:
		reject_event(event)


func change_input_event(event):
	var events = InputMap.action_get_events(action)
	InputMap.action_erase_events(action)
	events.remove_at(event_index)
	events.insert(event_index, event)
	for e in events:
		InputMap.action_add_event(action, e)
	button_pressed = false
	update_button()
	%RemapButtonManager.is_remapping_button = false
	grab_focus()
	

func reject_event(event):
	#DISPLAY MESSAGE
	print(event," IS ASSIGNED TO ANOTHER ACTION")
	Input.flush_buffered_events()
	set_process_unhandled_input(true)
	
