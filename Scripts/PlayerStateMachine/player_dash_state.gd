class_name PlayerDashState
extends PlayerState

#@export var dash_distance : float = 200
#@export var dash_time : float = 0.2
#@export var dash_push_multiplier : float = 1.5

@onready var dash_direction : Vector2 = Vector2.ZERO
@onready var dash_speed : float

func Enter():
	player.dash_button_reset = false
	dash_direction = get_direction()
	set_animation()

func set_animation():
	if dash_direction.y < -0.6:
		anim.play("dash_up")
	elif dash_direction.y > 0.6:
		anim.play("dash_down")
	else:
		anim.play("dash_ahead")

func get_direction() -> Vector2:
	if player.x_input == 0 && player.y_input == 0:
		return Vector2(player.facing_direction,0)	
	var multiplier : float = 1
	if player.x_input != 0 && player.y_input != 0:
		multiplier = 0.707107
	return Vector2 ((player.x_input * multiplier),(player.y_input * multiplier))

func Do_Checks():
	if time_in_current_state >= data.dash_time:
		complete_dash()

func Physics_Update(_delta):
	dash_speed = (data.dash_distance / data.dash_time)
	dash_speed = get_speed()
	player.velocity = Vector2 ((dash_direction.x * dash_speed), (dash_direction.y * dash_speed))
	player.move_and_slide()

func complete_dash():
	if player.is_grounded:
		Transitioned.emit(self,"Idle")
	else:
		player.velocity.y = 0
		$"../InAir".hang_time_active = true
		Transitioned.emit(self,"InAir")
		
func get_speed() -> float:
	if Input.is_action_pressed("Dash"):
		return dash_speed * data.dash_hold_multiplier
	else:
		return dash_speed
