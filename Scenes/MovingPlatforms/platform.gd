class_name Platform
extends AnimatableBody2D


@export var sink_distance : float = 0.0
@export var sink_delay : float = 0.25
@export var delay_wobble : float = 10.0
@export var sink_speed : float = 100
@export var rise_speed : float = 0.0

var path_follow : PathFollow2D
var momentum : Vector2 = Vector2.ZERO
var offset : Vector2 = Vector2.ZERO
var is_in_freefall : bool = false

@onready var player_detector : ShapeCast2D = %PlayerDetector
@onready var current_delay : float = sink_delay
#@onready var wobble_fade : float = delay_wobble / 6

var rng = RandomNumberGenerator.new()
#var wobble_strength : float = 0.0


func _physics_process(delta):
	if is_in_freefall:
		offset.y += sink_speed * delta
		position.y += offset.y * delta
	elif sink_distance > 0:	
		check_for_rider(delta)
#		if momentum.y != 0:
#			print(momentum.y)
		if path_follow:
			offset += momentum
			path_follow.h_offset = offset.x
			path_follow.v_offset = offset.y
		else:
			offset += momentum
			position += momentum
		
		momentum.x = 0

		
func check_for_rider(delta):
	if player_detector.is_colliding():
		if momentum.y < 0:
			momentum.y = 0
		if current_delay > 0:				
			wobble(delta)
		elif rise_speed <= 0:
			is_in_freefall = true
			if path_follow:
				break_from_path()
			sink(delta)
		elif offset.y < sink_distance:
			sink(delta)
	else:
		if rise_speed > 0:
			if offset.y > 0:
				rise(delta)
			else:
				momentum.y = 0
				if current_delay < sink_delay:
					current_delay += delta

func wobble(delta):
	current_delay -= delta
	if delay_wobble > 0:
		momentum.x = random_offset() - offset.x

func random_offset() -> float:
	return rng.randf_range(-delay_wobble, delay_wobble)

func sink(delta):
#	print("SINK")
	momentum.y += sink_speed * delta
	if momentum.y + offset.y > sink_distance && rise_speed > 0:
		momentum.y = sink_distance - offset.y

func rise(delta):
#	print("RISE")
	momentum.y -= rise_speed * delta
	if offset.y + momentum.y < 0:
		momentum.y = 0 - offset.y
#		print("changing momentum.y to ",momentum.y)
	
func break_from_path():
	path_follow.speed = 0
	path_follow.destroy_remote_transform()
