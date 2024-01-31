@tool
class_name LevelData
extends Node2D


@export_range(0.0, 50.0, 1.0, "or_less", "or_greater", "suffix:tiles") var top_boundary : float = 20.0:
	set(value):
		top_boundary = value
		calculate_rect()
@export_range(0.0, 50.0, 1.0, "or_less", "or_greater", "suffix:tiles") var left_boundary : float = 20.0:
	set(value):
		left_boundary = value
		calculate_rect()
@export_range(0.0, 50.0, 1.0, "or_less", "or_greater", "suffix:tiles") var right_boundary : float = 20.0:
	set(value):
		right_boundary = value
		calculate_rect()
@export_range(0.0, 50.0, 1.0, "or_less", "or_greater", "suffix:tiles") var bottom_boundary : float = 20.0:
	set(value):
		bottom_boundary = value
		calculate_rect()
@export var show_boundary_in_editor : bool = true:
	set(value):
		show_boundary_in_editor = value
		queue_redraw()

var level_boundary : Rect2:
	set(value):
		level_boundary = value
		queue_redraw()


func calculate_rect():
	level_boundary = Rect2(left_boundary * -110, top_boundary * -110, (left_boundary + right_boundary) * 110, (top_boundary + bottom_boundary) * 110)


func _draw():
	if Engine.is_editor_hint() && level_boundary && show_boundary_in_editor:
		draw_rect(level_boundary, Color(Color.GOLDENROD, 0.5))
	else:
		pass
