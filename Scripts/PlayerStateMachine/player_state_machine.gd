class_name PlayerStateMachine
extends Node


@export var initial_state : PlayerState
@export var current_state : PlayerState

#borrows verbose setting from Player node
@onready var verbose : bool = $"..".verbose

var states : Dictionary = {}


func _ready():
	for child in get_children():
		if child is PlayerState:
			states[child.name.to_lower()] = child
			child.Transitioned.connect(on_child_transition)
	
	if initial_state:
		initial_state.Transition()
		current_state = initial_state
		if verbose:
			print("Starting in ",current_state.name)


func _process(delta):
	if current_state:
		current_state.Initiate_Update(delta)


func _physics_process(delta):
	if current_state:
		current_state.Physics_Update(delta)
	
	
func on_child_transition(state, new_state_name):
#	if verbose:
#		print("Transition called from ",state.name," to ",new_state_name)
	if state != current_state && state != $"..":
		if verbose:
			print("Transition cancelled because ",state.name," is not the current state.")
		return
	
	var new_state = states.get(new_state_name.to_lower())
	if !new_state:
		return
		
	new_state.Transition()
	
	current_state = new_state
