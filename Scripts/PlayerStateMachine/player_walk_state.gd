class_name PlayerWalkState
extends PlayerState

@export var walk_speed : float = 150.0

func Enter():
	anim.play("walk",-1,1.25)
	
func Do_Checks():
	if !player.is_grounded:
		Transitioned.emit(self,"InAir")
	elif Input.is_action_pressed("Jump") && player.can_jump:
		Transitioned.emit(self,"Jump")
	elif player.x_input == 0:
		Transitioned.emit(self,"Idle")
	elif !Input.is_action_pressed("Slow"):
		Transitioned.emit(self,"Run")

func Physics_Update(delta):
	var motion = Vector2(walk_speed * delta * player.x_input, 0)
	player.move_and_collide(motion)
