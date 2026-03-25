extends GridContainer


var main_slider: HSlider 
var effect_slider: HSlider 
var music_slider: HSlider 
var ui_slider: HSlider 


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	
	var buttons:Array[HSlider]
	buttons.assign(NodeExtention.get_children_by_type(self, "HSlider"))
	main_slider = buttons[0]
	effect_slider = buttons[1]
	music_slider = buttons[2]
	ui_slider = buttons[3]
	
	main_slider.value_changed.connect(func(value):
		AudioServer.set_bus_volume_db(0, linear_to_db(value*.01))
		)
		
	effect_slider.value_changed.connect(func(value):
		AudioServer.set_bus_volume_db(1, linear_to_db(value*.01))
		)
		
	music_slider.value_changed.connect(func(value):
		AudioServer.set_bus_volume_db(2, linear_to_db(value*.01))
		)
		
	ui_slider.value_changed.connect(func(value):
		AudioServer.set_bus_volume_db(3, linear_to_db(value*.01))
		)
	
	# saving
	for button in [main_slider, effect_slider, music_slider, ui_slider]:
		button.value_changed.connect(save_audio_settings)
	
	# setting loaded values
	var loaded_settings: SettingsIo.SaveFile = SettingsIo.load_settings()
	main_slider.value = loaded_settings.volume_main
	effect_slider.value = loaded_settings.volume_effect
	music_slider.value = loaded_settings.volume_music
	ui_slider.value = loaded_settings.volume_ui
	
	# default button
	var default_button:Button = NodeExtention.get_child_by_type(self, "Button")
	default_button.pressed.connect(func():
		DefaultSettings.load_audio()
		
		# adjusting button selections
		main_slider.value = db_to_linear(DefaultSettings.volume_main)*100
		effect_slider.value = db_to_linear(DefaultSettings.volume_effect)*100
		music_slider.value = db_to_linear(DefaultSettings.volume_music)*100
		ui_slider.value = db_to_linear(DefaultSettings.volume_ui)*100
	)
	
	return

func save_audio_settings(_value: float) -> void:
	SettingsIo.save_audio_settings(
		main_slider.value,
		effect_slider.value,
		music_slider.value,
		ui_slider.value,
		)
