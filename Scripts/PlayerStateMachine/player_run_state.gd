class_name PlayerRunState
extends PlayerState

@export var run_speed = 420.0

func Enter():
	anim.play("run",-1,1.3)
	
func Do_Checks():
	if !player.is_grounded:
		$"../../CoyoteTime".start()
		Transitioned.emit(self,"InAir")
	elif Input.is_action_pressed("Jump") && player.jump_button_reset:
		Transitioned.emit(self,"Jump")
	elif Input.is_action_pressed("Dash") && player.dash_button_reset:
		Transitioned.emit(self,"Dash")
	elif player.x_input == 0:
		Transitioned.emit(self,"Idle")
	elif Input.is_action_pressed("Slow"):
		Transitioned.emit(self,"Walk")
		
func Physics_Update(delta):
	var motion = Vector2(run_speed * delta * player.x_input, 0)
	player.move_and_collide(motion)
