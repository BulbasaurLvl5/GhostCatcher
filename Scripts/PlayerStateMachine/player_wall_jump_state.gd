class_name PlayerWallJumpState
extends PlayerState

#@export var wall_jump_height: float = 100
#@export var wall_jump_time_to_peak: float = 0.2
#@export var wall_jump_force_duration: float = 0.1
#@export var float_multiplier: float = 2.7

@onready var jump_velocity : float
@onready var jump_gravity : float
@onready var in_air_horizontal_speed : float
@onready var wall_jump_direction : int

func Enter():
	anim.play("jump")
	player.facing_direction *= -1
	$"../../PlayerSprite2D".scale.x *= -1
	wall_jump_direction = player.facing_direction
	
	player.velocity.y = jump_velocity
	player.jump_button_reset = false
	jump_velocity = (-2 * data.wall_jump_height) / data.wall_jump_time_to_peak
	jump_gravity = (2 * data.wall_jump_height) / (data.wall_jump_time_to_peak * data.wall_jump_time_to_peak)
	in_air_horizontal_speed = data.in_air_horizontal_speed
	
func _animation_finished():
	anim.play("in-air")

func Do_Checks():
	if player.velocity.y >= 0:
		player.velocity.y = 0
		$"../InAir".hang_time_active = true
		Transitioned.emit(self,"InAir")
	elif player.can_touch_wall && player.x_input == player.facing_direction:
		player.velocity = Vector2.ZERO
		Transitioned.emit(self,"WallGrab")

func Physics_Update(delta):
	player.velocity.y += get_gravity() * delta
	var direction : int = wall_jump_direction * 2
	if time_in_current_state > data.wall_jump_force_duration:
		direction = player.facing_direction
	player.velocity.x = direction * data.in_air_horizontal_speed
	player.move_and_slide()
	
func get_gravity() -> float:
	if Input.is_action_pressed("Jump"):
		return jump_gravity/data.wall_jump_hold_multiplier
	else:
		return jump_gravity

#func Flip_Player():
#		player.facing_direction = -1
#		$"../../PlayerSprite2D".scale.x *= -1
