class_name PlayerWallJumpState
extends PlayerState


@onready var jump_velocity : float
@onready var jump_gravity : float
@onready var wall_jump_direction : int
var hold_time_remaining : float

func Enter():
	anim.play("jump")
	hold_time_remaining = data.jump_max_hold_time
	player.facing_direction *= -1
	anim.scale.x *= -1
	wall_jump_direction = player.facing_direction
	player.jump_button_reset = false
#	if player.verbose && player.moving_platform != null:
#		print("Player is LEAVING moving platform ",player.moving_platform)
#	player.moving_platform = null
	
	
func _animation_finished():
	anim.play("in-air")


func Do_Checks():
	if player.velocity.y > 0:
		%InAir.hang_time_active = true
		Transitioned.emit(self,"InAir")
	elif data.wall_grab_allowed_while_ascending && player.can_grab_wall() && time_in_current_state > 0.05:
		player.stop_motion()
		Transitioned.emit(self,"WallGrab")


func Physics_Update(delta):
	if player.jump_input && hold_time_remaining > 0:
		player.velocity.y = data.jump_force
		hold_time_remaining -= delta
	else:
		hold_time_remaining = 0
		player.velocity.y += data.gravity * delta

	var direction : int = wall_jump_direction * int(data.wall_jump_horizontal_force_multiplier)
	if time_in_current_state > data.wall_jump_force_duration:
		direction = player.facing_direction
	player.velocity.x = direction * data.in_air_horizontal_speed
	player.move_and_slide()
