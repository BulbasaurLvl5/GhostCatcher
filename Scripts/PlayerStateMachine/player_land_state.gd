class_name PlayerLandState
extends PlayerState

var heavy_landing : bool = false

func Enter():
	if heavy_landing:
		anim.play("land_heavy")
	else:
		anim.play("land_medium")

func DoChecks(_delta):
	if !heavy_landing:
		if Input.is_action_pressed("Jump") && player.can_jump:
			Transitioned.emit(self,"Jump")
		elif Input.is_action_pressed("Dash") && player.dash_button_reset&& player.last_dash_time + data.ground_dash_cooldown < Time.get_unix_time_from_system():
			Transitioned.emit(self,"Dash")
		elif abs(player.x_input) == 1:
			Walk_Or_Run(self)

func _animation_finished():
	if Input.is_action_pressed("Jump") && player.can_jump:
		Transitioned.emit(self,"Jump")
	elif abs(player.x_input) == 1:
		Walk_Or_Run(self)
	else:
		Transitioned.emit(self,"Idle")
