class_name SceneLib
extends Node
"""
This node is used to preload sub-resources inside a scene, so when the scene is loaded, 
all the resources are ready to use and can be retrieved from the preloader. 
-> has to be singleton, for preload to work
"""

# menus
var MENU_MAIN: PackedScene = preload("res://ui/menus/main/menu_main.tscn")
var MENU_LEVEL: PackedScene = load("res://ui/menus/level/menu_level.tscn") # preload causes error when loaded from menus for some unknown reasonn
var MENU_LEVEL_ELEMENT: PackedScene = preload("res://ui/menus/level/menu_level_element.tscn")
var MENU_OPTIONS: PackedScene = preload("res://ui/menus/options/menu_options.tscn")
var MENU_PAUSE: PackedScene = preload("res://ui/menus/pause/menu_pause.tscn")
var MENU_RETRY: PackedScene = preload("res://ui/menus/retry/menu_retry.tscn")

# textures
var RATING: Array[Texture2D] = [
		preload("res://assets/sprites/reaper/star_rating_0.png"), 
		preload("res://assets/sprites/reaper/star_rating_1.png"),
		preload("res://assets/sprites/reaper/star_rating_2.png"),
		preload("res://assets/sprites/reaper/star_rating_3.png"),
		preload("res://assets/sprites/reaper/star_rating_4.png"),
		preload("res://assets/sprites/reaper/star_rating_5.png"),
		]

# level
var TIME_LABEL: PackedScene = preload("res://ui/level_time_label.tscn")
var CENTER_LABEL: PackedScene = preload("res://ui/center_label.tscn")

var levels: Array = [
	LevelData.new("first steps", [3,4,5,7,9], load("res://main/levels/tutorial.tscn")), # again preload is causing problems
	#LevelData.new("Orc", 10)
]

func _ready() -> void:
	print("scene library singleton loaded as: "+self.name)
	pass # Replace with function body.

# helper class to organize level data. likely scene lib is not the right place for it
class LevelData:
	var name: String
	var times: Array[float]
	var scene: PackedScene


	func _init(_name: String, _times: Array[float], _scene: PackedScene):
		self.name = _name
		self.times = _times
		self.scene = _scene


	func score(time: float) -> int:
		if time == 0:
			return 0
		for i in range(times.size()):
			if time <= times[i]:
				return times.size() - i
		return 0
