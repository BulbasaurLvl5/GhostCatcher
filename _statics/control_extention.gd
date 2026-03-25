class_name ControlExtention
extends Object

enum _input_event_type { MOUSEBUTTON, JOYPADMOTION, JOYPADBUTTON, EVENTKEY }

static var _input_event_dict: Dictionary = {
	# Mouse Buttons
	"M:B:L": _new_inputevent(_input_event_type.MOUSEBUTTON, MouseButton.MOUSE_BUTTON_LEFT),
	"M:B:R": _new_inputevent(_input_event_type.MOUSEBUTTON, MouseButton.MOUSE_BUTTON_RIGHT),
	"M:B:M": _new_inputevent(_input_event_type.MOUSEBUTTON, MouseButton.MOUSE_BUTTON_MIDDLE),
	"M:B:WU": _new_inputevent(_input_event_type.MOUSEBUTTON, MouseButton.MOUSE_BUTTON_WHEEL_UP),
	"M:B:WD": _new_inputevent(_input_event_type.MOUSEBUTTON, MouseButton.MOUSE_BUTTON_WHEEL_DOWN),
	"M:B:WL": _new_inputevent(_input_event_type.MOUSEBUTTON, MouseButton.MOUSE_BUTTON_WHEEL_LEFT),
	"M:B:WR": _new_inputevent(_input_event_type.MOUSEBUTTON, MouseButton.MOUSE_BUTTON_WHEEL_RIGHT),
	
	# Joypad Axis	
	"J:A:LL": _new_inputevent(_input_event_type.JOYPADMOTION, JoyAxis.JOY_AXIS_LEFT_X, -.5),
	"J:A:LR": _new_inputevent(_input_event_type.JOYPADMOTION, JoyAxis.JOY_AXIS_LEFT_X, .5),
	"J:A:LU": _new_inputevent(_input_event_type.JOYPADMOTION, JoyAxis.JOY_AXIS_LEFT_Y, -.5),
	"J:A:LD": _new_inputevent(_input_event_type.JOYPADMOTION, JoyAxis.JOY_AXIS_LEFT_Y, .5),
	"J:A:RL": _new_inputevent(_input_event_type.JOYPADMOTION, JoyAxis.JOY_AXIS_RIGHT_X, -.5),
	"J:A:RR": _new_inputevent(_input_event_type.JOYPADMOTION, JoyAxis.JOY_AXIS_RIGHT_X, .5),
	"J:A:RU": _new_inputevent(_input_event_type.JOYPADMOTION, JoyAxis.JOY_AXIS_RIGHT_Y, -.5),
	"J:A:RD": _new_inputevent(_input_event_type.JOYPADMOTION, JoyAxis.JOY_AXIS_RIGHT_Y, .5),
	"J:A:TL": _new_inputevent(_input_event_type.JOYPADMOTION, JoyAxis.JOY_AXIS_TRIGGER_LEFT, .5),
	"J:A:TR": _new_inputevent(_input_event_type.JOYPADMOTION, JoyAxis.JOY_AXIS_TRIGGER_RIGHT, .5),
	
	# Joypad Buttons
	"J:B:A": _new_inputevent(_input_event_type.JOYPADBUTTON, JoyButton.JOY_BUTTON_A),
	"J:B:B": _new_inputevent(_input_event_type.JOYPADBUTTON, JoyButton.JOY_BUTTON_B),
	"J:B:X": _new_inputevent(_input_event_type.JOYPADBUTTON, JoyButton.JOY_BUTTON_X),
	"J:B:Y": _new_inputevent(_input_event_type.JOYPADBUTTON, JoyButton.JOY_BUTTON_Y),
	"J:B:L1": _new_inputevent(_input_event_type.JOYPADBUTTON, JoyButton.JOY_BUTTON_LEFT_SHOULDER),
	"J:B:R1": _new_inputevent(_input_event_type.JOYPADBUTTON, JoyButton.JOY_BUTTON_RIGHT_SHOULDER),
	#{ "JPBA", new InputEventJoypadButton { ButtonIndex = JoyButton.Back } },
	#{ "JPST", new InputEventJoypadButton { ButtonIndex = JoyButton.Start } },
	#{ "JPL3", new InputEventJoypadButton { ButtonIndex = JoyButton.L3 } }, there are two shoulder buttons left
	#{ "JPR3", new InputEventJoypadButton { ButtonIndex = JoyButton.R3 } }, there are two shoulder buttons left
	"J:B:DU": _new_inputevent(_input_event_type.JOYPADBUTTON, JoyButton.JOY_BUTTON_DPAD_UP),
	"J:B:DD": _new_inputevent(_input_event_type.JOYPADBUTTON, JoyButton.JOY_BUTTON_DPAD_DOWN),
	"J:B:DL": _new_inputevent(_input_event_type.JOYPADBUTTON, JoyButton.JOY_BUTTON_DPAD_LEFT),
	"J:B:DR": _new_inputevent(_input_event_type.JOYPADBUTTON, JoyButton.JOY_BUTTON_DPAD_RIGHT),
	#{ "joy_button_guide", new InputEventJoypadButton { ButtonIndex = JoyButton.Guide } }, no idea what that is

	# Keyboard letters
	"K:A": _new_inputevent(_input_event_type.EVENTKEY, Key.KEY_A),
	"K:B": _new_inputevent(_input_event_type.EVENTKEY, Key.KEY_B),
	"K:C": _new_inputevent(_input_event_type.EVENTKEY, Key.KEY_C),
	"K:D": _new_inputevent(_input_event_type.EVENTKEY, Key.KEY_D),
	"K:E": _new_inputevent(_input_event_type.EVENTKEY, Key.KEY_E),
	"K:F": _new_inputevent(_input_event_type.EVENTKEY, Key.KEY_F),
	"K:G": _new_inputevent(_input_event_type.EVENTKEY, Key.KEY_G),
	"K:H": _new_inputevent(_input_event_type.EVENTKEY, Key.KEY_H),
	"K:I": _new_inputevent(_input_event_type.EVENTKEY, Key.KEY_I),
	"K:J": _new_inputevent(_input_event_type.EVENTKEY, Key.KEY_J),
	"K:K": _new_inputevent(_input_event_type.EVENTKEY, Key.KEY_K),
	"K:L": _new_inputevent(_input_event_type.EVENTKEY, Key.KEY_L),
	"K:M": _new_inputevent(_input_event_type.EVENTKEY, Key.KEY_M),
	"K:N": _new_inputevent(_input_event_type.EVENTKEY, Key.KEY_N),
	"K:O": _new_inputevent(_input_event_type.EVENTKEY, Key.KEY_O),
	"K:P": _new_inputevent(_input_event_type.EVENTKEY, Key.KEY_P),
	"K:Q": _new_inputevent(_input_event_type.EVENTKEY, Key.KEY_Q),
	"K:R": _new_inputevent(_input_event_type.EVENTKEY, Key.KEY_R),
	"K:S": _new_inputevent(_input_event_type.EVENTKEY, Key.KEY_S),
	"K:T": _new_inputevent(_input_event_type.EVENTKEY, Key.KEY_T),
	"K:U": _new_inputevent(_input_event_type.EVENTKEY, Key.KEY_U),
	"K:V": _new_inputevent(_input_event_type.EVENTKEY, Key.KEY_V),
	"K:W": _new_inputevent(_input_event_type.EVENTKEY, Key.KEY_W),
	"K:X": _new_inputevent(_input_event_type.EVENTKEY, Key.KEY_X),
	"K:Y": _new_inputevent(_input_event_type.EVENTKEY, Key.KEY_Y),
	"K:Z": _new_inputevent(_input_event_type.EVENTKEY, Key.KEY_Z),
	
	# Keyboard Modifiers, Control, Arrows
	"K:ENTER": _new_inputevent(_input_event_type.EVENTKEY, Key.KEY_ENTER),
	"K:SPACE": _new_inputevent(_input_event_type.EVENTKEY, Key.KEY_SPACE),
	#{ "ESC", new InputEventKey { Keycode = Key.Escape } },
	"K:SHIFT": _new_inputevent(_input_event_type.EVENTKEY, Key.KEY_SHIFT),
	"K:CTRL": _new_inputevent(_input_event_type.EVENTKEY, Key.KEY_CTRL),
	"K:ALT": _new_inputevent(_input_event_type.EVENTKEY, Key.KEY_ALT),
	"K:TAB": _new_inputevent(_input_event_type.EVENTKEY, Key.KEY_TAB),
	#{ "key_capslock", new InputEventKey
	"K:-": _new_inputevent(_input_event_type.EVENTKEY, Key.KEY_MINUS),
	"K:+": _new_inputevent(_input_event_type.EVENTKEY, Key.KEY_PLUS),
	"K:,": _new_inputevent(_input_event_type.EVENTKEY, Key.KEY_COMMA),
	"K:.": _new_inputevent(_input_event_type.EVENTKEY, Key.KEY_PERIOD),
	"K:/": _new_inputevent(_input_event_type.EVENTKEY, Key.KEY_SLASH),
	"K:;": _new_inputevent(_input_event_type.EVENTKEY, Key.KEY_SEMICOLON),
	"K:'": _new_inputevent(_input_event_type.EVENTKEY, Key.KEY_APOSTROPHE),
	#{ "(", new InputEventKey { Keycode = Key.BracketLeft } },
	#{ ")", new InputEventKey { Keycode = Key.BracketRight } },
	#{ "\", new InputEventKey { Keycode = Key.Backslash } },
	#{ "", new InputEventKey { Keycode = Key.QuoteLeft } }, no way ... """ lol
	"K:INSERT": _new_inputevent(_input_event_type.EVENTKEY, Key.KEY_INSERT),
	"K:DEL": _new_inputevent(_input_event_type.EVENTKEY, Key.KEY_DELETE),
	#{ "key_home", new InputEventKey { Keycode = Key.Home } },
	"K:END": _new_inputevent(_input_event_type.EVENTKEY, Key.KEY_END),
	"K:PGUP": _new_inputevent(_input_event_type.EVENTKEY, Key.KEY_PAGEUP),
	"K:PGDWN": _new_inputevent(_input_event_type.EVENTKEY, Key.KEY_PAGEDOWN),
	"K:BACK": _new_inputevent(_input_event_type.EVENTKEY, Key.KEY_BACK),
	"K:UP": _new_inputevent(_input_event_type.EVENTKEY, Key.KEY_UP),
	"K:DOWN": _new_inputevent(_input_event_type.EVENTKEY, Key.KEY_DOWN),
	"K:LEFT": _new_inputevent(_input_event_type.EVENTKEY, Key.KEY_LEFT),
	"K:RIGHT": _new_inputevent(_input_event_type.EVENTKEY, Key.KEY_RIGHT),
	
	# Keyboard Numbers
	"K:0": _new_inputevent(_input_event_type.EVENTKEY, Key.KEY_0),
	"K:1": _new_inputevent(_input_event_type.EVENTKEY, Key.KEY_1),
	"K:2": _new_inputevent(_input_event_type.EVENTKEY, Key.KEY_2),
	"K:3": _new_inputevent(_input_event_type.EVENTKEY, Key.KEY_3),
	"K:4": _new_inputevent(_input_event_type.EVENTKEY, Key.KEY_4),
	"K:5": _new_inputevent(_input_event_type.EVENTKEY, Key.KEY_5),
	"K:6": _new_inputevent(_input_event_type.EVENTKEY, Key.KEY_6),
	"K:7": _new_inputevent(_input_event_type.EVENTKEY, Key.KEY_7),
	"K:8": _new_inputevent(_input_event_type.EVENTKEY, Key.KEY_8),
	"K:9": _new_inputevent(_input_event_type.EVENTKEY, Key.KEY_9),
	
	# Keyboard Function Keys
	"K:F1": _new_inputevent(_input_event_type.EVENTKEY, Key.KEY_F1),
	"K:F2": _new_inputevent(_input_event_type.EVENTKEY, Key.KEY_F2),
	"K:F3": _new_inputevent(_input_event_type.EVENTKEY, Key.KEY_F3),
	"K:F4": _new_inputevent(_input_event_type.EVENTKEY, Key.KEY_F4),
	"K:F5": _new_inputevent(_input_event_type.EVENTKEY, Key.KEY_F5),
	"K:F6": _new_inputevent(_input_event_type.EVENTKEY, Key.KEY_F6),
	"K:F7": _new_inputevent(_input_event_type.EVENTKEY, Key.KEY_F7),
	"K:F8": _new_inputevent(_input_event_type.EVENTKEY, Key.KEY_F8),
	"K:F9": _new_inputevent(_input_event_type.EVENTKEY, Key.KEY_F9),
	"K:F10": _new_inputevent(_input_event_type.EVENTKEY, Key.KEY_F10),
	"K:F11": _new_inputevent(_input_event_type.EVENTKEY, Key.KEY_F11),
	"K:F12": _new_inputevent(_input_event_type.EVENTKEY, Key.KEY_F12),
	
	# Keyboard numpad
	"NP:0": _new_inputevent(_input_event_type.EVENTKEY, Key.KEY_KP_0),
	"NP:1": _new_inputevent(_input_event_type.EVENTKEY, Key.KEY_KP_1),
	"NP:2": _new_inputevent(_input_event_type.EVENTKEY, Key.KEY_KP_2),
	"NP:3": _new_inputevent(_input_event_type.EVENTKEY, Key.KEY_KP_3),
	"NP:4": _new_inputevent(_input_event_type.EVENTKEY, Key.KEY_KP_4),
	"NP:5": _new_inputevent(_input_event_type.EVENTKEY, Key.KEY_KP_5),
	"NP:6": _new_inputevent(_input_event_type.EVENTKEY, Key.KEY_KP_6),
	"NP:7": _new_inputevent(_input_event_type.EVENTKEY, Key.KEY_KP_7),
	"NP:8": _new_inputevent(_input_event_type.EVENTKEY, Key.KEY_KP_8),
	"NP:9": _new_inputevent(_input_event_type.EVENTKEY, Key.KEY_KP_9),
	"NP:+": _new_inputevent(_input_event_type.EVENTKEY, Key.KEY_KP_ADD),
	"NP:-": _new_inputevent(_input_event_type.EVENTKEY, Key.KEY_KP_SUBTRACT),
	"NP:*": _new_inputevent(_input_event_type.EVENTKEY, Key.KEY_KP_MULTIPLY),
	"NP:/": _new_inputevent(_input_event_type.EVENTKEY, Key.KEY_KP_DIVIDE),
	"NP:,": _new_inputevent(_input_event_type.EVENTKEY, Key.KEY_KP_PERIOD),
	"NP:E": _new_inputevent(_input_event_type.EVENTKEY, Key.KEY_KP_ENTER),
}

static var input_events: Dictionary:
	get(): return _input_event_dict

static func _new_inputevent(type: _input_event_type, button_type: int, axis_val: float = .5) -> InputEvent:
	var e # returns null if unmatched
	
	match type:
		_input_event_type.MOUSEBUTTON:
			e = InputEventMouseButton.new()
			e.button_index = button_type
			return e
		
		_input_event_type.JOYPADMOTION:
			e = InputEventJoypadMotion.new()
			e.axis = button_type
			e.axis_value = axis_val
			return e
		
		_input_event_type.JOYPADBUTTON:
			e = InputEventJoypadButton.new()
			e.button_index = button_type
			return e
		
		_input_event_type.EVENTKEY:
			e = InputEventKey.new()
			e.keycode = button_type
			return e
		
		_:
			return e


static func event_to_string(input_event: InputEvent) -> String:
	
	for key in _input_event_dict:
		
		if (input_event is InputEventMouseButton and _input_event_dict[key] is InputEventMouseButton 
		and _input_event_dict[key].button_index == input_event.button_index):
			return key
	
		if (input_event is InputEventJoypadMotion and _input_event_dict[key] is InputEventJoypadMotion 
		and _input_event_dict[key].axis == input_event.axis 
		and abs(input_event.axis_value) >= .5 
		and sign(_input_event_dict[key].axis_value) == sign(input_event.axis_value) ):
			return key
		
		if (input_event is InputEventJoypadButton and _input_event_dict[key] is InputEventJoypadButton 
		and _input_event_dict[key].button_index == input_event.button_index):
			return key

		if (input_event is InputEventKey and _input_event_dict[key] is InputEventKey 
		and (_input_event_dict[key].keycode == input_event.keycode 
		or _input_event_dict[key].keycode == input_event.physical_keycode) ): # physical_keycode is engine settings default and layout independent
			return key
	
	#printerr("no key found in _inputEventDict for this event: ", input_event)
	return "unknown"


static func get_actions_using_event(input_event: InputEvent) -> Array[String]:
	var actions: Array[String]
	for my_action in ControlExtention.get_my_actions():
		for event in InputMap.action_get_events(my_action):
			if(event_to_string(input_event) == event_to_string(event)):
				actions.append(my_action)
	return actions


static func get_my_actions() -> Array[String]:
	var my_actions: Array[String]
	
	for action in InputMap.get_actions():
		if(not str(action).begins_with("ui_")):
			my_actions.append(action)
	
	return my_actions
