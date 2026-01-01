class_name Main
extends Node


var world: Node
var ui: Node
var audio: Node


func _ready() -> void:
	
	world = get_child(0)
	ui = get_child(1)
	audio = get_child(2)
	
	NodeExtention.instantiate(SceneLibrary.MENU_MAIN, ui)
	
	# load settings
	pass


func clear_scene():
	for _c in world.get_children():
		_c.queue_free()
		
	for _c in ui.get_children():
		_c.queue_free()
	pass
