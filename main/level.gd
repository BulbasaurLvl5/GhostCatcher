@tool
class_name Level
extends Node2D


const TILE_SIZE : float = 110.0

@export var level_name : String:
	set(value):
		if level_name == value:
			return
		level_name = value
		name = value
@export var show_data_in_editor : bool = false:
	set(value):
		if show_data_in_editor == value:
			return
		show_data_in_editor = value
		queue_redraw()
@export var air_actions_enabled : bool = true

@export_category("Player Starting Position")
@export_range(-50.0, 50.0, 0.5, "or_less", "or_greater", "suffix:tiles") var starting_position_x : float = 0.0:
	set(value):
		starting_position_x = value
		calculate_starting_pos()
@export_range(-50.0, 50.0, 0.5, "or_less", "or_greater", "suffix:tiles") var starting_position_y : float = 0.0:
	set(value):
		starting_position_y = value
		calculate_starting_pos()
@export var flip_player_direction : bool = false

@export_category("Level Boundary")
@export_range(-100.0, 0.0, 0.5, "or_less", "or_greater", "suffix:tiles") var top_boundary : float = -50.0:
	set(value):
		top_boundary = value
		calculate_boundary()
@export_range(-50.0, 0.0, 0.5, "or_less", "or_greater", "suffix:tiles") var left_boundary : float = -20.0:
	set(value):
		left_boundary = value
		calculate_boundary()
@export_range(0.0, 150.0, 0.5, "or_less", "or_greater", "suffix:tiles") var right_boundary : float = 20.0:
	set(value):
		right_boundary = value
		calculate_boundary()
@export_range(0.0, 50.0, 0.5, "or_less", "or_greater", "suffix:tiles") var bottom_boundary : float = 20.0:
	set(value):
		bottom_boundary = value
		calculate_boundary()

var level_boundary : Rect2:
	set(value):
		level_boundary = value
		queue_redraw()
var starting_pos : Vector2:
	set(value):
		starting_pos = value
		queue_redraw()

var player : Player:
	set(value):
		if player == value:
			return
		else:
			player = value
			#player.position = starting_pos
			player.level_boundary = level_boundary
			player.air_actions_enabled = air_actions_enabled
			if !air_actions_enabled:
				player.remaining_air_actions = 0
			print("Player found by level.gd AIR ACTIONS SET TO: ", player.remaining_air_actions)
var camera : Camera2D:
	set(value):
		if camera == value:
			return
		else:
			camera = value
			camera.level_boundary = level_boundary


func calculate_boundary():
	level_boundary = Rect2(left_boundary * TILE_SIZE, top_boundary * TILE_SIZE, (right_boundary - left_boundary) * TILE_SIZE, (bottom_boundary - top_boundary) * TILE_SIZE)
	show_data_in_editor = true


func calculate_starting_pos():
	starting_pos = Vector2(starting_position_x * TILE_SIZE, starting_position_y * TILE_SIZE)
	show_data_in_editor = true


func _enter_tree():
	if !Engine.is_editor_hint():
		search_scene()
		if get_parent() == get_tree().root:
			player.process_mode = Node.PROCESS_MODE_ALWAYS


func _ready():
	if !Engine.is_editor_hint():
		if !player || !camera:
			search_scene()
	else:
		level_name = name
		renamed.connect(_on_renamed)
		show_data_in_editor = false


func _process(_delta):
	if !Engine.is_editor_hint():
		if !player || !camera:
			#print("level_parameters _process() calling search_scene()")
			search_scene()
	elif level_name != name:
		level_name = name


func _draw():
	if Engine.is_editor_hint() && show_data_in_editor:
		if level_boundary:
			draw_rect(level_boundary, Color(Color.GOLDENROD, 0.25))
		draw_rect(Rect2(starting_pos.x - (TILE_SIZE * 0.5), starting_pos.y - (TILE_SIZE * 0.5), TILE_SIZE, TILE_SIZE), Color(Color.CRIMSON, 0.5))
		draw_rect(Rect2(starting_pos.x - (TILE_SIZE * 1.5), starting_pos.y - (TILE_SIZE * 1.5), (TILE_SIZE * 3.0), (TILE_SIZE * 3.0)), Color(Color.FUCHSIA, 0.25))
	else:
		pass


func search_scene():
	var nodes = get_all_children(get_tree().root)
	if !player:
		for n in nodes:
			if n is Player:
				player = n
				break
	if !camera:
		for n in nodes:
			if n is Camera2D:
				camera = n
				break


func get_all_children(node) -> Array:
	if !node:
		return []
	var all_children : Array = []
	var children = node.get_children()
	for c in children:
		if c.get_child_count() > 0:
			all_children.append(c)
			all_children.append_array(get_all_children(c))
		else:
			all_children.append(c)
	return all_children


func _on_renamed():
	if name != level_name:
		level_name = name
