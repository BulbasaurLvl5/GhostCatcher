class_name PlayerDieState
extends PlayerState

func _enter_state() -> void:
	anim.play("die")
	print("You have died!   Press 9 to revive")

func _process(_delta):
	if Input.is_action_pressed("Revive"):
		print("Death has granted you another chance...")
		fsm.change_state(idle_state)
