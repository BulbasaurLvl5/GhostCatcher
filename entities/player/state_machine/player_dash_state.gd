class_name PlayerDashState
extends PlayerState


@export var dash_ghost_node : PackedScene
@export var shockwave_scene : PackedScene

@onready var ghost_timer : float = 0

@onready var dash_direction : Vector2 = Vector2.ZERO
@onready var dash_speed : float
@onready var recovering : bool


func Enter(_from : PlayerState = null):
	recovering = false
	player.height_fallen_from = player.position.y
	player.dash_button_reset = false
	set_animation()
	add_ghost()
	create_shockwave()
	$"../../SFX/Dash".play()


func set_animation():
	if dash_direction.y < -0.6:
		anim.play("dash")
	elif dash_direction.y > 0.6:
		anim.play("dash")
	else:
		anim.play("dash")


func Do_Checks():
	if player.can_grab_wall():
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
			#create_shockwave()


func Physics_Update(_delta):
	player.velocity = Vector2.ZERO
	if !recovering:
		dash_speed = get_speed()
		player.velocity.x = player.facing_direction * dash_speed 
	player.move()


func complete_dash():	
	if player.super_state == player.SuperStates.GROUNDED:
		Transitioned.emit(self,"Idle")
	else:
		player.stop_motion()
		Transitioned.emit(self,"InAir")
		
		
func get_speed() -> float:
	#WOULD A TWEEN BE BETTER HERE?
	
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


func create_shockwave():
	var shockwave = shockwave_scene.instantiate()
	get_tree().current_scene.add_child(shockwave)
	shockwave.facing_direction = player.facing_direction
	shockwave.position = Vector2(player.position.x, player.position.y)
	shockwave.motion = Vector2.ZERO
	shockwave.start()
	
	
func Exit():
	player.last_dash_time = Time.get_unix_time_from_system()
