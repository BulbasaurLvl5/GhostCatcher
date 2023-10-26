class_name PlayerRunState
extends PlayerState

@export var run_speed = 10.0

func Enter():
	anim.play("run",-1,1.3)
	
func Do_Checks():
	if !player.is_grounded:
		Transitioned.emit(self,"InAir")
	elif Input.is_action_pressed("Jump") && player.can_jump:
		Transitioned.emit(self,"Jump")
	elif player.x_input == 0:
		Transitioned.emit(self,"Idle")
	elif Input.is_action_pressed("Slow"):
		Transitioned.emit(self,"Walk")
		
func Physics_Update(delta):
	var motion = Vector2(run_speed * delta * player.x_input, 0)
	player.move_and_collide(motion)
