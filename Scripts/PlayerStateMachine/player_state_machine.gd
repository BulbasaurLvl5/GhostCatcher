class_name PlayerStateMachine
extends Node

@export var player_state: PlayerState

func _ready():
	change_state(player_state)
	
func change_state(new_state: PlayerState):
	if player_state is PlayerState:
		player_state._exit_state()
	new_state._enter_state()
	player_state = new_state
	print("player_state switched to ",new_state)
	
