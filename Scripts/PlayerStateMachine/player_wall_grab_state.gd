class_name PlayerWallGrabState
extends PlayerState

@export var wall_grab_resets_air_actions : bool = true

func Enter():
	anim.play("wall_grab")
	if wall_grab_resets_air_actions:
		player.remaining_air_actions = player.max_air_actions

func Do_Checks():
	
	if !Input.is_action_pressed("Grab"):
		release_wall()	

func release_wall():
	if player.is_grounded:
		Transitioned.emit(self,"Idle")
	else:
		$"../../CoyoteTime".start()
		player.last_touched_wall = true
		Transitioned.emit(self,"InAir")

func Flip_Player():
	#cannot flip while grabbing wall
	pass
