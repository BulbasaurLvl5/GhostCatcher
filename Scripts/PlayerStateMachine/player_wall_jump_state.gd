class_name PlayerWallJumpState
extends PlayerState


@onready var jump_velocity : float
@onready var jump_gravity : float
@onready var wall_jump_direction : int


func Enter():
	anim.play("jump")
	player.facing_direction *= -1
	$"../../PlayerAnimatedSprite2D".scale.x *= -1
	wall_jump_direction = player.facing_direction

	player.jump_button_reset = false
	jump_velocity = (-2 * data.wall_jump_height) / data.wall_jump_time_to_peak
	jump_gravity = (2 * data.wall_jump_height) / (data.wall_jump_time_to_peak * data.wall_jump_time_to_peak)
	player.velocity.y = jump_velocity
	
	
func _animation_finished():
	anim.play("in-air")


func Do_Checks():
	if player.velocity.y >= 0:
		player.velocity.y = 0
		$"../InAir".hang_time_active = true
		Transitioned.emit(self,"InAir")
	elif data.wall_grab_allowed_while_ascending && player.can_touch_wall && player.x_input == player.facing_direction && time_in_current_state > 0.05:
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
