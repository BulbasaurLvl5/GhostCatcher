extends Node
"""
used to store global runtime state
"""

# state from level to pause+retry menu
var current_level: SceneLibrary.LevelData
var level_time: float
var level_success = false


func _ready() -> void:
	print("game state singleton loaded as: "+self.name)
	pass # Replace with function body.


func current_level_idx() -> int:
	return SceneLibrary.levels.find(current_level)
