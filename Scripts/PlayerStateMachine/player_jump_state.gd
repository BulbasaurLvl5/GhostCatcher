class_name PlayerJumpState
extends PlayerState

#@export var move_speed: float = 350
#@export var jump_height: float = 100
#@export var jump_time_to_peak: float = 0.2
#@export var float_multiplier: float = 2.7

@onready var jump_velocity : float 
@onready var jump_gravity : float 

func Enter():
	anim.play("jump")
	player.velocity.y = jump_velocity
	player.jump_button_reset = false
	jump_velocity = (-2 * data.jump_height) / data.jump_time_to_peak
	jump_gravity = (2 * data.jump_height) / (data.jump_time_to_peak * data.jump_time_to_peak)
	
func _animation_finished():
	anim.play("in_air")

func Do_Checks():
	if player.velocity.y >= 0:
		player.velocity.y = 0
		$"../InAir".hang_time_active = true
		Transitioned.emit(self,"InAir")

func Physics_Update(delta):
	player.velocity.y += get_gravity() * delta
	player.velocity.x = data.in_air_horizontal_speed * player.x_input
	player.move_and_slide()
	
func get_gravity() -> float:
	if Input.is_action_pressed("Jump"):
		return jump_gravity/data.jump_hold_multiplier
	else:
		return jump_gravity
