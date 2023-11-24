class_name PlayerJumpState
extends PlayerState


@onready var jump_velocity : float 
@onready var jump_gravity : float 


func Enter():
	anim.play("jump")
	player.jump_button_reset = false
	jump_velocity = (-2 * data.jump_height) / data.jump_time_to_peak
	jump_gravity = (2 * data.jump_height) / (data.jump_time_to_peak * data.jump_time_to_peak)
	player.velocity.y = jump_velocity
	
	
func _animation_finished():
	anim.play("in_air")


func Do_Checks():
	if player.velocity.y >= 0:
		player.velocity.y = 0
		$"../InAir".hang_time_active = true
		Transitioned.emit(self,"InAir")
	elif data.wall_grab_allowed_while_ascending && player.can_touch_wall && player.x_input == player.facing_direction:
		player.velocity = Vector2.ZERO
		Transitioned.emit(self,"WallGrab")


func Physics_Update(delta):
	player.velocity.y += get_gravity() * delta
	player.velocity.x = data.in_air_horizontal_speed * player.x_input
	player.move_and_slide()

	
func get_gravity() -> float:
	if Input.is_action_pressed("Jump"):
		return jump_gravity/data.jump_hold_multiplier
	else:
		return jump_gravity
