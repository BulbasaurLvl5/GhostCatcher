class_name Radar2D
extends Node2D

signal screen_moved
signal viewport_changed
signal pointer_radius_changed


@export var radar_active : bool = false
@export var pointer_margin : Vector2 = Vector2(100.0, 100.0)
@onready var canvas : CanvasLayer = %CanvasLayer
@onready var control : Control = %Control

var screen_center_pos : Vector2 = Vector2.ZERO:
	set(value):
		if value != screen_center_pos:
			screen_moved.emit(value)
			screen_center_pos = value
var viewport_size : Vector2:
	set(value):
		if value != viewport_size:
			viewport_changed.emit(value)
			pointer_radius_changed.emit(value / 2 - pointer_margin)
			viewport_size = value
var camera : Camera2D:
	get:
		var viewport = get_viewport()
		if viewport:
			return viewport.get_camera_2d()
		return null


func _ready():
	var w = ProjectSettings.get_setting("display/window/size/viewport_width")
	var h = ProjectSettings.get_setting("display/window/size/viewport_height")
	viewport_size = Vector2(w, h)
	add_to_group("radar_2d")
	print("Viewport size according to radar_2d = ", viewport_size)


func _process(_delta):
	if !radar_active:
		return
	screen_center_pos = camera.get_screen_center_position()
#	viewport_size = get_viewport().size
#	print("Viewport size according to radar_2d = ", viewport_size)
#	get_tree().get_nodes_in_group()
