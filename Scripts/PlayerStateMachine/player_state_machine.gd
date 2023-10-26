class_name PlayerStateMachine
extends Node

@export var initial_state : PlayerState

var current_state : PlayerState
var states : Dictionary = {}

func _ready():
	for child in get_children():
		if child is PlayerState:
			states[child.name.to_lower()] = child
			child.Transitioned.connect(on_child_transition)
	
	if initial_state:
		initial_state.Enter()
		current_state = initial_state
		print("Starting in ",current_state)

func _process(delta):
	if current_state:
			current_state.Update()

func _physics_process(delta):
	if current_state:
		current_state.Physics_Update()
	
func on_child_transition(state, new_state_name):
	if state != current_state:
			return
	
	var new_state = states.get(new_state_name.to_lower())
	if !new_state:
		return
		
	new_state.Enter()
	
	current_state = new_state
	print("Transitioning to ",current_state)
		
		
		
		
		
	# OLD VERSION
#	player_state = $PlayerIdleState
#	player_state._enter_state()
#	print("starting in ",player_state)
#
#func change_state(new_state: PlayerState):
#	if player_state != new_state:
#		player_state._exit_state()
#		new_state._enter_state()
#		player_state = new_state
#		print("player_state switched to ",new_state)
#



