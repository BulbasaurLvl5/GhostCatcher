extends Node
"""
https://docs.godotengine.org/en/stable/tutorials/inputs/controllers_gamepads_joysticks.html#window-focus

The problem we are trying to solve:
When the game is minimized, controller input is not blocked

" Unlike keyboard input, controller inputs can be seen by all windows on the operating system, including unfocused windows (our game).
If you wish to ignore events when the project window isn't focused, 
you will need to create an autoload called Focus with the following script and use it to check all your inputs... "

The documented solution force you to rewrite all input
this script aims to solve this by 
1 stripping the inputmap of ALL input events in inputmap
2 store them
3 finally reapply when focusing back

It has to be done dynamically everytime, because we have to assume that the events change via input remapping
"""

var controls:Dictionary[String, Array] = {}


func _ready() -> void:
	print("focus singleton loaded.")
	process_mode = Node.PROCESS_MODE_ALWAYS


func _notification(notification_id):
	match notification_id:
		NOTIFICATION_APPLICATION_FOCUS_OUT:
			disable_all_input()
			EnergySaver.enter_idle() # optional
		NOTIFICATION_APPLICATION_FOCUS_IN:
			enable_all_input()
			EnergySaver.exit_idle() # optional


func enable_all_input() -> void:
	for action in controls:
		for event in controls[action]:
			InputMap.action_add_event(action, event)
	return


func disable_all_input() -> void:
	for action in InputMap.get_actions():
		controls[action] = InputMap.action_get_events(action)
		InputMap.action_erase_events(action)
	return
