class_name PlayerInAirState
extends PlayerState

@export var fall_gravity_multiplier: float = .05
@export var max_fall_time: float = 2.0

@onready var fall_gravity : float = ((2 * $"../Jump".jump_height) / ($"../Jump".jump_time_to_descent * $"../Jump".jump_time_to_peak))
@onready var move_speed : float = $"../Jump".move_speed

func Enter():
	anim.play("in_air")
	
func Do_Checks():
	if player.is_grounded:
		if time_in_current_state > max_fall_time:
			Transitioned.emit(self,"Die")
		elif player.x_input == 0:
			Transitioned.emit(self,"Land")
		else:
			player_move_states(self)

func Update(delta):
	pass

func Physics_Update(delta):
	player.velocity.y += fall_gravity * fall_gravity_multiplier
	player.velocity.x = player.x_input * move_speed
	player.move_and_slide()
