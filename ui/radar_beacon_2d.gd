class_name RadarBeacon2D
extends Node2D


var radar : Radar2D
var pointer : RadarPointer2D
var screen_center_pos : Vector2 = Vector2.ZERO:
	set(value):
		if value != screen_center_pos:
			screen_center_pos = value
			check_relative_position()
var viewport_size : Vector2:
	set(value):
		if value != viewport_size:
			viewport_size = value
			if pointer:
				pointer.radius_from_center = viewport_size / 2 - radar.pointer_margin
			check_relative_position()
var last_position : Vector2:
	set(value):
		if value != last_position:
			last_position = value
			check_relative_position()
var direction : Vector2:
	set(value):
		if value != direction:
			pointer.direction = value

@export var active : bool = true:
	set(value):
		if value != active:
			pointer.beacon_active = value
			active = value
@export var pointer_texture : Texture2D
@export var pointer_rotates : bool = true
@export var pointer_color_mod : Color = Color.WHITE
@export var pointer_scale : Vector2 = Vector2.ONE


func _ready():
	var w = ProjectSettings.get_setting("display/window/size/viewport_width")
	var h = ProjectSettings.get_setting("display/window/size/viewport_height")
	viewport_size = Vector2(w, h)


func _process(_delta):
	last_position = global_position
	if !radar:
		radar = get_tree().get_first_node_in_group("radar_2d")
		if radar:
			if !radar.tree_exiting.is_connected(_on_radar_tree_exiting):
				radar.tree_exiting.connect(_on_radar_tree_exiting)
	if radar && !pointer:
		create_pointer()


func create_pointer():
	pointer = RadarPointer2D.new()
	radar.canvas.add_child(pointer)
	pointer.beacon = self
	pointer.texture = pointer_texture
	pointer.rotates = pointer_rotates
	pointer.self_modulate = pointer_color_mod
	pointer.scale = pointer_scale
	pointer.radius_from_center = viewport_size / 2.0 - radar.pointer_margin
	pointer.beacon_active = active
	self.tree_exiting.connect(pointer._on_beacon_exiting_tree)
	radar.pointer_radius_changed.connect(pointer._on_pointer_radius_changed)
	radar.viewport_changed.connect(_on_viewport_changed)
	radar.screen_moved.connect(_on_screen_moved)


func check_relative_position():
	if radar && !pointer:
		create_pointer()
	if !pointer:
		return
	if abs(screen_center_pos.x - global_position.x) > viewport_size.x / 2.0 || abs(screen_center_pos.y - global_position.y) > viewport_size.y / 2.0:
		pointer.pointer_active = true
	else:
		pointer.pointer_active = false	
	direction = screen_center_pos.direction_to(global_position)


func _on_screen_moved(new_pos : Vector2):
	screen_center_pos = new_pos

func _on_viewport_changed(value : Vector2):
	viewport_size = value
	
func _on_radar_tree_exiting():
	radar = null
