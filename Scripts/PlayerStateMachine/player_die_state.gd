class_name PlayerDieState
extends PlayerState

func Enter():
	anim.play("idle")
	print("You have died!   Press 9 to revive")

func Do_Checks():
	if Input.is_action_pressed("Revive") && time_in_current_state > 0.5:
		print("Death has granted you another chance...")
		Transitioned.emit(self,"Idle")

func Flip_Player():
	#cannot flip while dead
	pass
