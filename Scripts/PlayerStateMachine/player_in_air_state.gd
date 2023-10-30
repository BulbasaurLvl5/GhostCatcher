class_name PlayerInAirState
extends PlayerState

@export var hang_time_duration : float = 0.1
@export var fall_gravity_multiplier : float = 5
@export var distance_before_medium_landing : float = 500
@export var distance_before_heavy_landing : float = 1000
@export var distance_before_dying : float = 2000

@onready var fall_gravity : float = ((1.3 * $"../Jump".jump_height) / ($"../Jump".jump_time_to_peak * $"../Jump".jump_time_to_peak))
@onready var move_speed : float = $"../Jump".move_speed
@onready var hang_time_active : bool = false

var distance_fallen : float
var height_fallen_from : float
var time_since_grounded : float

func Enter():
	anim.play("in_air")
	height_fallen_from = player.position.y
	
func Do_Checks():
	distance_fallen = (player.position.y - height_fallen_from)
	
	if player.is_grounded:
		hang_time_active = false
		if verbose:
			print("distance fallen = ",distance_fallen)
		if distance_fallen > distance_before_dying:
			Transitioned.emit(self,"Die")
		elif distance_fallen > distance_before_medium_landing:
			if distance_fallen > distance_before_heavy_landing:
				$"../Land".heavy_landing = true
			else:
				$"../Land".heavy_landing = false
			Transitioned.emit(self,"Land")
		elif player.x_input == 0:
			Transitioned.emit(self,"Idle")
		else: 
			Walk_Or_Run(self)
	elif Input.is_action_pressed("Jump") && player.can_jump():
		player.air_action()
		Transitioned.emit(self,"Jump")
	elif Input.is_action_pressed("Dash") && player.can_dash():
		player.air_action()
		Transitioned.emit(self,"Dash")
	elif Input.is_action_pressed("Grab") && player.can_touch_wall:
		player.velocity = Vector2.ZERO
		Transitioned.emit(self,"WallGrab")
		
func Update(_delta):
	if hang_time_active && time_in_current_state > hang_time_duration:
		hang_time_active = false

func Physics_Update(_delta):
	if hang_time_active:
		player.velocity.y = 0
	else:
		player.velocity.y += fall_gravity * fall_gravity_multiplier * .001
	player.velocity.x = player.x_input * move_speed
	player.move_and_slide()
