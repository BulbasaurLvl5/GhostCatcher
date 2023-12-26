class_name PlayerInAirState
extends PlayerState


@onready var fall_gravity : float
@onready var in_air_horizontal_speed : float
@onready var hang_time_active : bool = false

var height_fallen_from : float
var time_since_grounded : float


func Enter():
	player.can_touch_wall = false
	if player.momentum.y <= 100 || hang_time_active:
		anim.play("hover")
	else:
		anim.play("fall")
	Flip_Player()
	height_fallen_from = player.position.y
	fall_gravity = ((1.3 * data.jump_height) / (data.jump_time_to_peak * data.jump_time_to_peak))
	in_air_horizontal_speed = data.in_air_horizontal_speed
#	if player.verbose && player.moving_platform != null:
#		print("Player is LEAVING moving platform ",player.moving_platform)
	player.moving_platform = null
	
	
func Do_Checks():
	if height_fallen_from > player.position.y:
		height_fallen_from = player.position.y
	
	if player.is_grounded:
		hang_time_active = false
		var distance_fallen = (player.position.y - height_fallen_from)
#		if verbose:
#			print("distance fallen = ",distance_fallen)
		if distance_fallen > data.distance_before_dying:
			Transitioned.emit(self,"Die")
		elif distance_fallen > data.distance_before_medium_landing:
			if distance_fallen > data.distance_before_heavy_landing:
				%Land.heavy_landing = true
			else:
				%Land.heavy_landing = false
			Transitioned.emit(self,"Land")
		elif player.x_input == 0:
			Transitioned.emit(self,"Idle")
		else: 
			Transitioned.emit(self,"Run")
	elif player.jump_input && player.can_jump():
		player.air_action()
		Transitioned.emit(self,"Jump")
	elif player.dash_input && player.can_dash():
		player.air_action()
		Transitioned.emit(self,"Dash")
	elif player.can_touch_wall && player.x_input == player.facing_direction:
		player.stop_motion()
		if verbose:
			print("grabbing wall from IN AIR    ......    can_touch_wall is ",player.can_touch_wall)
		Transitioned.emit(self,"WallGrab")
	
		
func Update(_delta):
	if hang_time_active && time_in_current_state > data.hang_time_duration:
		hang_time_active = false
		anim.play("fall", true)


func Physics_Update(delta):
	var motion = Vector2.ZERO
	if hang_time_active:
		motion.y = 0
	else:
		motion.y = move_toward(player.momentum.y, data.max_fall_speed, data.gravity * delta)
	motion.x = player.x_input * data.in_air_horizontal_speed * delta
	player.move_xy(motion)
