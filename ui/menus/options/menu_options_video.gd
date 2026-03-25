extends GridContainer

var buttons: Array[OptionButton]

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	
	#for c in get_children():
		#if c is OptionButton:
			#buttons.append(c)
	
	buttons.assign(NodeExtention.get_children_by_type(self, "OptionButton"))
	
	# vsync
	for vs in VideoExtention.vsync_dict.keys():
		buttons[0].add_item(vs)
	
	buttons[0].item_selected.connect(func(idx):
		VideoExtention.vsync_dict[buttons[0].get_item_text(idx)].call()
		)
	
	# window mode
	for ws in VideoExtention.window_mode_dict.keys():
		buttons[1].add_item(ws)

	buttons[1].item_selected.connect(func(idx):
		VideoExtention.window_mode_dict[buttons[1].get_item_text(idx)].call()
		)
	
	# window size
	for ws in VideoExtention.window_size_dict.keys():
		buttons[2].add_item(ws)

	buttons[2].item_selected.connect(func(idx):
		VideoExtention.window_size_dict[buttons[2].get_item_text(idx)].call()
		)
	
	# saving
	for button in buttons:
		button.item_selected.connect(save_video_settings)
	
	# adjusting button selections
	var loaded_settings: SettingsIo.SaveFile = SettingsIo.load_settings()
	buttons[0].select(get_option_index_by_text(buttons[0], loaded_settings.vsync))
	buttons[1].select(get_option_index_by_text(buttons[1], loaded_settings.window_mode))
	buttons[2].select(get_option_index_by_text(buttons[2], loaded_settings.window_size))
	
	# default button
	var default_button:Button = NodeExtention.get_child_by_type(self, "Button")
	default_button.pressed.connect(func():
		DefaultSettings.load_video()
		
		# adjusting button selections
		buttons[0].select(DefaultSettings.vsync)
		
		if (DefaultSettings.window_mode == DisplayServer.WINDOW_MODE_FULLSCREEN):
			buttons[1].select(0)
		elif (DefaultSettings.window_mode == DisplayServer.WINDOW_MODE_WINDOWED):
			buttons[1].select(1)
		
		for i in range(buttons[2].get_item_count()):
			var text = buttons[2].get_item_text(i)
			if (text.contains(str(DefaultSettings.window_size[0]))
				and text.contains(str(DefaultSettings.window_size[1])) ):
				buttons[2].select(i)
		
		save_video_settings(0)
		)


func save_video_settings(_idx: int) -> void:
	SettingsIo.save_video_settings(
		buttons[0].get_item_text(buttons[0].get_selected()),
		buttons[1].get_item_text(buttons[1].get_selected()),
		buttons[2].get_item_text(buttons[2].get_selected())
		)


func get_option_index_by_text(option_button: OptionButton, text: String) -> int:
	for i in range(option_button.item_count):
		if option_button.get_item_text(i) == text:
			return i
	return -1 # not found
