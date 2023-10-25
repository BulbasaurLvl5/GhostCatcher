class_name PlayerStateMachine
extends Node

@export var player_state: PlayerState

func _ready():
	player_state = $PlayerInAirState
	player_state._enter_state()
	print("starting in ",player_state)
	
func change_state(new_state: PlayerState):
	if player_state != new_state:
		player_state._exit_state()
		new_state._enter_state()
		player_state = new_state
		print("player_state switched to ",new_state)
