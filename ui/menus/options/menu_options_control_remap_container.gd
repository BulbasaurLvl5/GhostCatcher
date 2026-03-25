extends GridContainer
class_name RemapButtonContainer

## Number of different keys that can be assined to an action
@export var max_bindings: int = 4

var allow_button_multi_use: bool = false
signal on_events_changed()

var label: Label:
	get: 
		if not label:
			label = get_child(0)
		return label

var button: Button
#var input_strings: Array[String]

var _is_handling_input: bool: # using button state as state
	set(value):
		button.disabled = value
	get:
		return button.disabled


func _ready() -> void:
	button = get_child(2)
	set_button_text()
	
	button.connect("pressed", func():
		button.text = "..."
		_is_handling_input = true
		#await get_tree().process_frame # wait 1 frame to ignore first button press (enter)
		)
	return


func _input(input_event):
	if(_is_handling_input and ControlExtention.event_to_string(input_event) != "unknown"):
		InputMap.action_add_event(StringName(label.text), input_event)
		
		var actions_using_event: Array[String] = ControlExtention.get_actions_using_event(input_event)
		var number_events: int =  InputMap.action_get_events(StringName(label.text)).size()
		
		if not allow_button_multi_use:
			for action in actions_using_event:
				if action != label.text:
					InputMap.action_erase_event(action, input_event)
			
		if number_events > max_bindings:
			InputMap.action_erase_event(StringName(label.text), InputMap.action_get_events(StringName(label.text))[0])
			
		set_button_text()
		get_viewport().set_input_as_handled() # stops further processing
		_is_handling_input = false
		on_events_changed.emit()


func set_button_text() -> void:
	var concat_string: Array[String]
	for event in InputMap.action_get_events(StringName(label.text)):
		concat_string.append(ControlExtention.event_to_string(event))
	button.text = ", ".join(concat_string)
