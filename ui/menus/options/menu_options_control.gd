extends GridContainer

## Allows for a key event / button press to be asigned to multiple intput map actions. Such that e.g. skill1 and skill2 can both be activated be pressing E. 
## This state is forwarded to the remap button containers 
@export var allow_button_multi_use: bool = false

var remap_container: Array[RemapButtonContainer]


func _ready() -> void:	
	var remap_button_container: RemapButtonContainer = get_child(0)
	var default_button_container = get_child(1)
	var default_button = NodeExtention.get_child_by_type(default_button_container, "Button")
	
	for my_action in ControlExtention.get_my_actions():
		#print(input, " added to list")
		var new_container: RemapButtonContainer = remap_button_container.duplicate()
		new_container.label.text = my_action # before add_child, bc container does sth in ready
		new_container.allow_button_multi_use = allow_button_multi_use
		add_child(new_container)
		
		remap_container.append(new_container)
		new_container.on_events_changed.connect(set_remap_button_texts)
		new_container.on_events_changed.connect(save_control_settings)
	
	remap_button_container.queue_free() # lazily delete original container after copying
	
	# default button
	move_child(default_button_container, get_child_count() - 1) # move default container to bottom
	default_button.pressed.connect(func() -> void:
		DefaultSettings.load_controls()
		set_remap_button_texts()
		save_control_settings()
		)
	
	return


func set_remap_button_texts() -> void:
	for button in remap_container:
		button.set_button_text()
	return


func save_control_settings() -> void:
	var save_controls_dict: Dictionary = {}
	for _rmc in remap_container:
		var keys: Array[String]
		for key in _rmc.button.text.split(","):
			keys.append(key.strip_edges())
		save_controls_dict[_rmc.label.text] = keys
	SettingsIo.save_control_settings(save_controls_dict)
	return
