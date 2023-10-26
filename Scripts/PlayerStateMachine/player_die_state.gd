class_name PlayerDieState
extends PlayerState

func Enter():
	anim.play("die")
	print("You have died!   Press 9 to revive")

func Do_Checks():
	if Input.is_action_pressed("Revive"):
		print("Death has granted you another chance...")
		Transitioned.emit(self,"player_idle_state")
