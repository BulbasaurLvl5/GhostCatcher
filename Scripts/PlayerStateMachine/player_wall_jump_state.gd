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
	$"../../PlayerAnimatedSprite2D".scale.x *= -1
	wall_jump_direction = player.facing_direction
	player.jump_button_reset = false
	
	
func _animation_finished():
	anim.play("in-air")


func Do_Checks():
	if player.momentum.y > 0:
		$"../InAir".hang_time_active = true
		Transitioned.emit(self,"InAir")
	elif data.wall_grab_allowed_while_ascending && player.can_touch_wall && player.x_input == player.facing_direction && time_in_current_state > 0.05:
		player.stop_motion()
		Transitioned.emit(self,"WallGrab")


func Physics_Update(delta):
	var motion = Vector2.ZERO
	if player.jump_input && hold_time_remaining > 0:
		motion.y = data.jump_force * delta
		hold_time_remaining -= delta
	else:
		hold_time_remaining = 0
		motion.y = move_toward(player.momentum.y, data.max_fall_speed, data.gravity * delta)
	var direction : int = wall_jump_direction * 2
	if time_in_current_state > data.wall_jump_force_duration:
		direction = player.facing_direction
	motion.x = direction * data.in_air_horizontal_speed * delta
	player.move_xy(motion)


