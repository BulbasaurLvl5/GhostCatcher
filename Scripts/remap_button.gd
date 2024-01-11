class_name RemapButton
extends Button


@export var actions : Array[String]
@export var event_indexes : Array[int]

var remap_button_manager : RemapButtonManager


func _ready():
	var menu_items : Array[Node]
	menu_items = $"..".get_children()
	for item in menu_items:
		if item is RemapButtonManager:
			remap_button_manager = item


func update_button():
	set_process_unhandled_input(false)
	var event_name : String = "%s" % InputMap.action_get_events(actions[0])[event_indexes[0]].as_text()
	var count : int = 0
	var name_was_shortened : bool = false
	for string in remap_button_manager.input_name_substitutions:
		if event_name.begins_with(string) && count < remap_button_manager.input_name_substitutions.size()-1:
			event_name = remap_button_manager.input_name_substitutions[count+1]
			name_was_shortened = true
			break
		count += 1
	if !name_was_shortened && event_name.length() > 12:
		print(event_name," should be added to the input name-shortening database.")
	text = event_name


func _process(_delta):
	if visible:
		_update()


func _update():
	if button_pressed:
		release_focus()
		if !remap_button_manager.is_remapping_button:
			remap_button_manager.is_remapping_button = true
			text = "....."
			set_process_unhandled_input(true)


func _unhandled_input(event):
	Input.flush_buffered_events()
	if event.as_text() == InputMap.action_get_events(actions[0])[event_indexes[0]].as_text():
		change_input_event(event)
		return
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
	event.set_pressed(false)
	var action_is_available : bool = true
	var event_actions = InputMap.get_actions()
	for a in event_actions:
		if !a.begins_with("ui"):
			var events = InputMap.action_get_events(a)
			for e in events:
				if e.as_text() == event.as_text():
					action_is_available = false
					if e is InputEventJoypadMotion:
						if event.get_axis_value() != e.get_axis_value():
							action_is_available = true
	if action_is_available:
		change_input_event(event)
	else:
		reject_event(event)


func change_input_event(event):
	var count = 0
	for a in actions:
		var events = InputMap.action_get_events(a)
		InputMap.action_erase_events(a)
		events.remove_at(event_indexes[count])
		events.insert(event_indexes[count], event)
		for e in events:
			InputMap.action_add_event(a, e)
		count += 1
	button_pressed = false
	update_button()
	remap_button_manager.is_remapping_button = false
	grab_focus()
	

func reject_event(event):
	#THIS MESSAGE SHOULD BE DISPLAYED TO THE PLAYER
	#THIS MESSAGE SHOULD BE DISPLAYED TO THE PLAYER
	#THIS MESSAGE SHOULD BE DISPLAYED TO THE PLAYER
	print(event," is already assigned. Please choose a different input.")
	set_process_unhandled_input(true)
	
