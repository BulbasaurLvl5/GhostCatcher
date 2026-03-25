class_name Main
extends Node


static var world: Node2D
static var ui: CanvasLayer
static var music: Music


func _ready() -> void:
	world = get_child(0)
	ui = get_child(1)
	music = get_child(2)
	
	NodeExtention.instantiate(ui, SceneLibrary.MENU_MAIN)
	return


static func clear_scene():
	for _c in world.get_children():
		_c.queue_free()
		
	for _c in ui.get_children():
		_c.queue_free()
	return

#static func world_instatiate(node):
	#NodeExtention.instantiate(world, node, ...)

#static func ui_instatiate(node):
	#NodeExtention.instantiate(ui, node, ...)
