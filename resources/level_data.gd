@tool
class_name LevelData
extends Node2D


@export var show_data_in_editor : bool = true:
	set(value):
		show_data_in_editor = value
		queue_redraw()

@export_category("Level Boundary")
@export_range(-100.0, 0.0, 0.5, "or_less", "or_greater", "suffix:tiles") var top_boundary : float = -50.0:
	set(value):
		top_boundary = value
		calculate_boundary()
@export_range(-50.0, 0.0, 0.5, "or_less", "or_greater", "suffix:tiles") var left_boundary : float = -20.0:
	set(value):
		left_boundary = value
		calculate_boundary()
@export_range(0.0, 50.0, 0.5, "or_less", "or_greater", "suffix:tiles") var right_boundary : float = 20.0:
	set(value):
		right_boundary = value
		calculate_boundary()
@export_range(0.0, 50.0, 0.5, "or_less", "or_greater", "suffix:tiles") var bottom_boundary : float = 20.0:
	set(value):
		bottom_boundary = value
		calculate_boundary()

@export_category("Player Starting Position (Inactive)")
@export_range(-50.0, 50.0, 0.5, "or_less", "or_greater", "suffix:tiles") var starting_position_x : float = 0.0:
	set(value):
		starting_position_x = value
		calculate_starting_pos()
@export_range(-50.0, 50.0, 0.5, "or_less", "or_greater", "suffix:tiles") var starting_position_y : float = 0.0:
	set(value):
		starting_position_y = value
		calculate_starting_pos()

var level_boundary : Rect2:
	set(value):
		level_boundary = value
		queue_redraw()
var starting_pos : Vector2:
	set(value):
		starting_pos = value
		queue_redraw()


func calculate_boundary():
	level_boundary = Rect2(left_boundary * 110, top_boundary * 110, (right_boundary - left_boundary) * 110, (bottom_boundary - top_boundary) * 110)

func calculate_starting_pos():
	starting_pos = Vector2(starting_position_x * 110, starting_position_y * 110)


func _draw():
	if Engine.is_editor_hint() && show_data_in_editor:
		if level_boundary:
			draw_rect(level_boundary, Color(Color.GOLDENROD, 0.25))
		draw_rect(Rect2(starting_pos.x - 55, starting_pos.y - 55, 110, 110), Color(Color.CRIMSON, 1.0))
		draw_rect(Rect2(starting_pos.x - 165, starting_pos.y - 165, 330, 330), Color(Color.FUCHSIA, 0.25))
	else:
		pass
