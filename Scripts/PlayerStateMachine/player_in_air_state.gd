class_name PlayerInAirState
extends PlayerState

func _enter_state() -> void:
	anim.play("in_air")
	
func _process(delta):
	#do checks
	if player.is_on_floor() && player.input_direction.x == 0:
		fsm.change_state(land_state)
	#else if 

func _physics_process(delta):	
	#fall
	player.velocity.y += delta * player.player_gravity
	var motion = player.velocity * delta
	player.move_and_collide(motion)
