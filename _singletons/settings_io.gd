#class_name SettingsIO
extends Node
"""
singleton to manage settings saved to disc
singleton bc it needs to load settings when game starts
"""

var base_path: String:
	get():
		if OS.has_feature("editor"):
			return ProjectSettings.globalize_path("user://")
		else:
			# Returns the absolute directory path where user data is written (user://).
			return OS.get_user_data_dir()

var file_path: String:
	get():
		return base_path+"settings.json"


func _ready() -> void:
	print("settings_io singleton loaded as: %s. \n   It saves data to %s" % [self.name, base_path])
	# By default, the user:// folder is created within Godot's editor data path in the app_userdata/[project_name] folder
	# windows: C:/Users/[user]/AppData/Roaming/Godot/app_userdata/[project_name]/
	# linux: /home/[user]/.local/share/godot/app_userdata/[project_name]/
	
	if not FileAccess.file_exists(file_path):
		_save_file_to_disc(SaveFile.new())
		print("   %s not found -> new default created" % file_path)
		return
	
	# apply saved settings on start
	var loaded_settings: SaveFile = load_settings()
	
	VideoExtention.vsync_dict[loaded_settings.vsync].call()
	VideoExtention.window_mode_dict[loaded_settings.window_mode].call()
	VideoExtention.window_size_dict[loaded_settings.window_size].call()
	
	AudioServer.set_bus_volume_db(0, linear_to_db(loaded_settings.volume_main*.01))
	AudioServer.set_bus_volume_db(1, linear_to_db(loaded_settings.volume_effect*.01))
	AudioServer.set_bus_volume_db(2, linear_to_db(loaded_settings.volume_music*.01))
	AudioServer.set_bus_volume_db(3, linear_to_db(loaded_settings.volume_ui*.01))
	
	for action in loaded_settings.controls:
		InputMap.action_erase_events(action)
		for binding in loaded_settings.controls[action]:
			InputMap.action_add_event(action, ControlExtention.input_events[binding])
	
	return


func _save_file_to_disc(save_file: SaveFile) -> void:
	var save_file_dict: Dictionary = save_file.to_Dict()
	var file = FileAccess.open(file_path, FileAccess.WRITE)
	file.store_string(JSON.stringify(save_file_dict))
	file.close()
	return


func load_settings() -> SaveFile:
	var data: SaveFile = SaveFile.new()
	
	if not FileAccess.file_exists(file_path):
		_save_file_to_disc(data)
		print("   %s not found -> new default created" % file_path)
		return data
	
	var file = FileAccess.open(file_path, FileAccess.READ)
	var content = file.get_as_text()
	file.close()
	var json = JSON.new()
	var error = json.parse(content)
	if error == OK:
		data = SaveFile.new(json.get_data())
	else:
		_save_file_to_disc(data)
		print("   json parsing failed -> new default created")
	
	return data


func save_video_settings(vsync: String, window_mode: String, window_size: String) -> void:
	if (not VideoExtention.vsync_dict.keys().has(vsync) or 
		not VideoExtention.window_size_dict.keys().has(window_size) or
		not VideoExtention.window_mode_dict.keys().has(window_mode)):
			print("key not found in video settings, abort save")
			return
	
	var loaded_settings: SaveFile = load_settings()
	loaded_settings.vsync = vsync
	loaded_settings.window_size = window_size
	loaded_settings.window_mode = window_mode
	_save_file_to_disc(loaded_settings)
	
	return


func save_audio_settings(main_volume: float, effect_volume: float, music_volume: float, ui_volume: float) -> void:
	var loaded_settings: SaveFile = load_settings()
	loaded_settings.volume_main = main_volume
	loaded_settings.volume_effect = effect_volume
	loaded_settings.volume_music = music_volume
	loaded_settings.volume_ui = ui_volume
	_save_file_to_disc(loaded_settings)
	return


func save_control_settings(controls: Dictionary) -> void:
	for action in controls:
		for binding in controls[action]:
			if not ControlExtention.input_events.has(binding):
				print(binding+" not found in ctrl settings, abort save")
				return
	
	var loaded_settings: SaveFile = load_settings()
	loaded_settings.controls = controls
	_save_file_to_disc(loaded_settings)
	
	return



class SaveFile:
	"""
	this class's job is to translate between a plain class and godot.dict
	godot.dict is one of the few types godot can save to json
	"""
	
	var vsync: String
	var window_mode: String
	var window_size: String
		
	var volume_main: float
	var volume_effect: float
	var volume_music: float
	var volume_ui: float
		
	var controls: Dictionary


	func _init(input_dict: Dictionary = {}):
		vsync = input_dict.get("vsync", VideoExtention.vsync_dict.keys()[2])
		window_mode = input_dict.get("window_mode", VideoExtention.window_mode_dict.keys()[0])
		window_size = input_dict.get("window_size", VideoExtention.window_size_dict.keys()[-1])
		
		volume_main = input_dict.get("volume_main", 100.0)
		volume_effect = input_dict.get("volume_effect", 100.0)
		volume_music = input_dict.get("volume_music", 100.0)
		volume_ui = input_dict.get("volume_ui", 100.0)
		
		controls = input_dict.get("controls", {})


	func to_Dict() -> Dictionary:
		var _settings: Dictionary = {
			"vsync": vsync,
			"window_mode": window_mode,
			"window_size": window_size,
			
			"volume_main": volume_main,
			"volume_effect": volume_effect,
			"volume_music": volume_music,
			"volume_ui": volume_ui,
			
			"controls": controls,
			}
		return _settings
