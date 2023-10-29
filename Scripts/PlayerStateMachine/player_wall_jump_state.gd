class_name PlayerWallJumpState
extends PlayerState

@export var wall_jump_height: float = 100
@export var wall_jump_time_to_peak: float = 0.2
@export var wall_jump_force_duration: float = 0.1
@export var float_multiplier: float = 2.7

@onready var jump_velocity : float = (-2 * wall_jump_height) / wall_jump_time_to_peak
@onready var jump_gravity : float = (2 * wall_jump_height) / (wall_jump_time_to_peak * wall_jump_time_to_peak)
@onready var move_speed : float = $"../Jump".move_speed

func Enter():
	anim.play("jump")
	player.velocity.y = jump_velocity
	player.jump_button_reset = false
	
func _animation_finished():
	anim.play("in-air")

func Physics_Update(delta):
	#determine Y velocity
	#switch to InAir state if falling
	if player.velocity.y >= 0:
		Transitioned.emit(self,"InAir")
	else:
		player.velocity.y += get_gravity() * delta
	#determine X velocity
	var momentum : float = 1
	if time_in_current_state > wall_jump_force_duration:
		momentum = player.x_input
	player.velocity.x = momentum * move_speed
	player.move_and_slide()
	
func get_gravity() -> float:
	if Input.is_action_pressed("Jump"):
		return jump_gravity/float_multiplier
	else:
		return jump_gravity

func Flip_Player():
	if time_in_current_state > wall_jump_force_duration && player.facing_direction != player.x_input && abs(player.x_input) == 1:
		player.facing_direction = player.x_input
		$"../../PlayerSprite2D".scale.x *= -1
