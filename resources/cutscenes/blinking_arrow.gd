@tool
class_name BlinkingArrow
extends Sprite2D


@export var active : bool = true:
	set(value):
		if active == value:
			return
		active = value
		self_modulate.a = 0.0
		if active:
			time_to_appear = blink_delay
			time_to_blink = blink_speed
@export var blink_delay : float = 3.0
@export var blink_speed : float = 0.5
@onready var time_to_appear : float = blink_delay
@onready var time_to_blink : float = blink_speed


func _process(delta):
	if !active:
		return
		
	if time_to_appear > 0:
		time_to_appear -= delta
	else:
		time_to_blink -= delta
		if time_to_blink <= 0:
			blink()


func blink():
	if self_modulate.a == 1.0:
		self_modulate.a = 0.0
	else:
		self_modulate.a = 1.0
	queue_redraw()
	time_to_blink = blink_speed
