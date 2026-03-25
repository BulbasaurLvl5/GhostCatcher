extends Node

"""
loggs data to disc
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
		return base_path+"logs.json"


func _ready() -> void:
	print("logger singleton loaded as: %s. \n   It saves data to %s" % [self.name, base_path])
	# By default, the user:// folder is created within Godot's editor data path in the app_userdata/[project_name] folder
	# windows: C:/Users/[user]/AppData/Roaming/Godot/app_userdata/[project_name]/
	# linux: /home/[user]/.local/share/godot/app_userdata/[project_name]/
	
	if not FileAccess.file_exists(file_path):
		create_new()
		print("   %s not found -> new default created" % file_path)
		return
	#else:
		#append("game started")


func _date_time() -> String:
	var dt = Time.get_datetime_dict_from_system()
	var date_time = "%04d-%02d-%02d %02d:%02d:%02d" % [
		dt.year,
		dt.month,
		dt.day,
		dt.hour,
		dt.minute,
		dt.second
	]
	return date_time


func create_new() -> void:
	var file = FileAccess.open(file_path, FileAccess.WRITE)
	file.store_string(_date_time() + " game first started and new log created")
	file.close()
	return


func append(string:String) -> void:
	var file = FileAccess.open(file_path, FileAccess.READ_WRITE)
	file.seek_end()
	file.store_string("\n" + _date_time() + " " + string)
	file.close()
	return
