class_name FileIO
extends Node
"""
singleton to manage data saved to disc
singleton bc it needs to check file state when game starts
"""

static var base_path: String:
	get():
		if OS.has_feature("editor"):
			return ProjectSettings.globalize_path("user://")
		else:
			# Returns the absolute directory path where user data is written (user://).
			return OS.get_user_data_dir()
			
static var file_path: String:
	get():
		return base_path+"save.json"
		
#enum SaveFileKeys {
	#LAST_TIMES,
	#BEST_TIMES
#}

"""
enum like, but keys map to strings instead of ints
gds can call String keys like OOP e.g. SaveFileKeys.LAST_TIMES
first entry is OOP like, second one is what is written in save file
"""
const SaveFileKeys: Dictionary = {
	"LAST_TIMES" = "last times",
	"BEST_TIMES" = "best times"
}


func _ready() -> void:
	print("file_io singleton loaded as: %s. \n   It saves data to %s" % [self.name, base_path])
	# By default, the user:// folder is created within Godot's editor data path in the app_userdata/[project_name] folder
	# windows: C:/Users/John/AppData/Roaming/Godot/app_userdata/GhostCatcher/
	# linux: /home/john/.local/share/godot/app_userdata/Temporal_Reaper/
	if not FileAccess.file_exists(file_path):
		_savefile_to_disc(SaveFile.new())
		print("   save.json not found. New blank created")
		return
	
	var save_file: SaveFile = load_file()
	if (save_file.best_times.size() != SceneLibrary.levels.size() || 
			save_file.last_times.size() != SceneLibrary.levels.size() ):
		_savefile_to_disc(SaveFile.new())
		print("   level.size mismatch while loading. New blank created")
	
	pass


func _savefile_to_disc(save_file: SaveFile) -> void:
	var save_dict: Dictionary = save_file.to_Dict()
	
	var file = FileAccess.open(file_path, FileAccess.WRITE)
	file.store_string(JSON.stringify(save_dict))
	file.close()
	pass


func save_time(key: String, idx: int, time: float) -> void:
	var save_file: SaveFile = load_file()
	if (key == SaveFileKeys.LAST_TIMES):
		save_file.last_times[idx] = time
	elif (key == SaveFileKeys.BEST_TIMES):
		save_file.best_times[idx] = time
	_savefile_to_disc(save_file)
	pass


func load_file() -> SaveFile:
	var data: Dictionary = SaveFile.new().to_Dict()
	
	if not FileAccess.file_exists(file_path):
		_savefile_to_disc(SaveFile.new())
	
	var file = FileAccess.open(file_path, FileAccess.READ)
	var content = file.get_as_text()
	file.close()
	var json = JSON.new()
	var error = json.parse(content)
	if error == OK:
		data = json.get_data()
	else:
		_savefile_to_disc(SaveFile.new())
		#push_error("Failed to parse JSON file", data)
	return SaveFile.new(data)


class SaveFile:
	"""
	this class's job is to translate between a plain class and godot.dict
	godot.dict is one of the few types godot can save to json
	"""
	
	var last_times: Array[float]
	var best_times: Array[float]
	
	
	func _init(saved_dict: Dictionary = {SaveFileKeys.LAST_TIMES: [], SaveFileKeys.BEST_TIMES: []}):
		if saved_dict.get(SaveFileKeys.LAST_TIMES).size() == 0 || saved_dict.get(SaveFileKeys.BEST_TIMES).size() == 0: # blank init
			var size: int = SceneLibrary.levels.size()
			last_times.resize(size)
			last_times.fill(0)
			best_times.resize(size)
			best_times.fill(0)
		else:
			var temp: Array = saved_dict.get(str(SaveFileKeys.LAST_TIMES))
			for v in temp:
				last_times.append(float(v))
			
			temp = saved_dict.get(str(SaveFileKeys.BEST_TIMES))
			for v in temp: 
				best_times.append(float(v))
	
	
	func to_Dict() -> Dictionary[String, Array]:
		"""
		function that matches godot.dict save behaviour
		keys / enums / ints will be saved as strings ...
		arrays are not allowed to be typed...
		"""
		var _return: Dictionary[String, Array] = {
				str(SaveFileKeys.LAST_TIMES): self.last_times,
				str(SaveFileKeys.BEST_TIMES): self.best_times
				}
		return _return
