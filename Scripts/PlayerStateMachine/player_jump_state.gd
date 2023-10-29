class_name PlayerJumpState
extends PlayerState

@export var move_speed: float = 350
@export var jump_height: float = 100
@export var jump_time_to_peak: float = 0.2
@export var float_multiplier: float = 2.7

@onready var jump_velocity : float = (-2 * jump_height) / jump_time_to_peak
@onready var jump_gravity : float = (2 * jump_height) / (jump_time_to_peak * jump_time_to_peak)

func Enter():
	anim.play("jump")
	player.velocity.y = jump_velocity
	player.jump_button_reset = false
	
func _animation_finished():
	anim.play("in-air")

func Physics_Update(delta):
	#determine Y velocity
	#switch to InAir state if falling
	if player.velocity.y >= 0:
		player.velocity.y = 0
		$"../InAir".hang_time_active = true
		Transitioned.emit(self,"InAir")
	else:
		player.velocity.y += get_gravity() * delta
	#determine X velocity
	player.velocity.x = move_speed * player.x_input
	player.move_and_slide()
	
func get_gravity() -> float:
	if Input.is_action_pressed("Jump"):
		return jump_gravity/float_multiplier
	else:
		return jump_gravity
