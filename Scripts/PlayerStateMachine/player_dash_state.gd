class_name PlayerDashState
extends PlayerState


@export var dash_ghost_node : PackedScene
@onready var ghost_timer : float = 0

@onready var dash_direction : Vector2 = Vector2.ZERO
@onready var dash_speed : float
@onready var recovering : bool


func Enter():
	recovering = false
	player.last_dash_time = Time.get_unix_time_from_system()
	player.dash_button_reset = false
	dash_direction = get_direction()
	set_animation()
	add_ghost()
	$"../../SFX/Dash".play()
#	if player.verbose && player.moving_platform != null:
#		print("Player is LEAVING moving platform ",player.moving_platform)
	player.moving_platform = null


func set_animation():
	if dash_direction.y < -0.6:
		anim.play("dash")
	elif dash_direction.y > 0.6:
		anim.play("dash")
	else:
		anim.play("dash")


func get_direction() -> Vector2:
	if player.x_input == 0 && player.y_input == 0 || data.only_horizontal_dashing_allowed:
		return Vector2(player.facing_direction,0)	
	var multiplier : float = 1
	if player.x_input != 0 && player.y_input != 0:
		multiplier = 0.707107
	return Vector2 ((player.x_input * multiplier),(player.y_input * multiplier))


func Do_Checks():
	if player.is_facing_wall:
		Transitioned.emit(self,"WallGrab")
	if time_in_current_state >= data.dash_time + data.dash_recovery_time:
		complete_dash()
	elif !recovering && time_in_current_state >= data.dash_time:
		recovering = true
	
		
		
func Update(delta):
	if !recovering:
		ghost_timer -= delta
		if ghost_timer <= 0:
			add_ghost()


func Physics_Update(delta):
	var motion : Vector2
	if !recovering:
		dash_speed = get_speed()
		motion = dash_direction * dash_speed * delta
	player.move_xy(motion)


func complete_dash():	
	if player.is_grounded:
		Transitioned.emit(self,"Idle")
	else:
		player.stop_motion()
		$"../InAir".hang_time_active = true
		Transitioned.emit(self,"InAir")
		
		
func get_speed() -> float:
	if time_in_current_state < data.dash_time * 0.5:
		dash_speed = 4 * lerp(0, int(data.dash_peak_speed), 0.5-(data.dash_time * 0.5 - time_in_current_state))
	else:
		dash_speed = 4 * lerp(int(data.dash_peak_speed), 0, 2 * time_in_current_state / data.dash_time - 1)
	if player.dash_input:
		return dash_speed * data.dash_hold_multiplier
	else:
		return dash_speed


func add_ghost():
	var dash_ghost = dash_ghost_node.instantiate()
	dash_ghost.set_property(anim.frame, player.position, anim.scale)
	get_tree().current_scene.add_child((dash_ghost))
	ghost_timer = 0.02


func Flip_Player():
	#cannot flip while dashing
	pass
