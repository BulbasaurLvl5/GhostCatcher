class_name PlayerWallJumpState
extends PlayerState


@onready var jump_velocity : float
@onready var jump_gravity : float
@onready var wall_jump_direction : int

var hold_time_remaining : float


func Enter(_from : PlayerState = null):
	if player.y_input < 0:
		Transitioned.emit(self,"Jump")
		return
	anim.play("jump")
	hold_time_remaining = data.jump_max_hold_time
	Flip_Player(true)
	wall_jump_direction = player.facing_direction
	player.jump_button_reset = false
	
	
func _animation_finished():
	anim.play("in-air")


func Do_Checks():
	Check_Altitude()
	if player.velocity.y > 0:
		%InAir.hang_time_active = true
		Transitioned.emit(self,"InAir")
	elif player.can_jump():
		player.air_action()
		Transitioned.emit(self,"Jump")
	elif player.can_dash() && !player.jump_input:
		player.air_action()
		Transitioned.emit(self,"Dash")
	elif player.can_stomp() && !player.jump_input:
		Transitioned.emit(self,"Stomp")
	elif player.velocity.y >= 0 || player.get_collisions(Vector2.UP):
		%InAir.hang_time_active = true
		Transitioned.emit(self,"InAir")
	elif player.can_grab_wall() && player.y_input >= 0 && time_in_current_state > 0.05:
		player.stop_motion()
		Transitioned.emit(self,"WallGrab")
	elif time_in_current_state > data.wall_jump_force_duration || !player.jump_input:
		Flip_Player()
		
	
func Physics_Update(delta):
	if player.jump_input && hold_time_remaining > 0:
		player.velocity.y = data.jump_force
		hold_time_remaining -= delta
	else:
		hold_time_remaining = 0
		player.velocity.y += data.gravity * delta

	player.velocity.x = player.facing_direction * data.in_air_horizontal_speed
	player.move_and_slide()
