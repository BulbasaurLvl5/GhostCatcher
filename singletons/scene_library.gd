extends Node

# menus
var MENU_MAIN: PackedScene = preload("res://ui/menus/menu_main.tscn")
var MENU_LEVEL: PackedScene = preload("res://ui/menus/menu_level.tscn")
var MENU_LEVEL_ELEMENT: PackedScene = preload("res://ui/menus/menu_level_element.tscn")
var MENU_OPTIONS: PackedScene = preload("res://ui/menus/menu_options.tscn")
var MENU_PAUSE: PackedScene = preload("res://ui/menus/menu_pause.tscn")
var MENU_RETRY: PackedScene = preload("res://ui/menus/menu_retry.tscn")

# textures
var RATING_0: Texture2D = preload("res://resources/sprites/reaper/star_rating_0.png")
var RATING_1: Texture2D = preload("res://resources/sprites/reaper/star_rating_1.png")
var RATING_2: Texture2D = preload("res://resources/sprites/reaper/star_rating_2.png")
var RATING_3: Texture2D = preload("res://resources/sprites/reaper/star_rating_3.png")
var RATING_4: Texture2D = preload("res://resources/sprites/reaper/star_rating_4.png")
var RATING_5: Texture2D = preload("res://resources/sprites/reaper/star_rating_5.png")

# level
var TIME_LABEL: PackedScene = preload("res://ui/level_time_label.tscn")
var CENTER_LABEL: PackedScene = preload("res://ui/center_label.tscn")

var levels: Array = [
	LevelData.new("first steps", [5,7,9,12,15], preload("res://levels/tutorial.tscn")),
	#LevelData.new("Orc", 10)
]

func _ready() -> void:
	print("scene library singleton loaded as : "+self.name)
	pass # Replace with function body.

# helper class to organize level data
class LevelData:
	var name: String
	var times: Array[float]
	var scene: PackedScene

	func _init(_name: String, _times: Array[float], _scene: PackedScene):
		self.name = _name
		self.times = _times
		self.scene = _scene


	func score(time: float) -> int:
		#for i in range(times.size()):
			#if time <= times[i]:
				#return times.size() - i
		return 0
