class_name PlayerLandState
extends PlayerState

var heavy_landing : bool = false

func Enter():
	if heavy_landing:
		anim.play("land_heavy")
	else:
		anim.play("land_medium")

func DoChecks(delta):
	if !heavy_landing:
		if Input.is_action_pressed("Jump") && player.can_jump:
			Transitioned.emit(self,"Jump")
		elif abs(player.x_input) == 1:
			Walk_Or_Run(self)

func _animation_finished():
	if Input.is_action_pressed("Jump") && player.can_jump:
		Transitioned.emit(self,"Jump")
	elif abs(player.x_input) == 1:
		Walk_Or_Run(self)
	else:
		Transitioned.emit(self,"Idle")
