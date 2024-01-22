class_name MobStateMachine
extends Node


@export var ai : MobAI
@export var initial_state : MobState

var current_state : MobState
var states : Dictionary = {}
	

func _ready():
	if !ai && $".." is MobAI:
		ai = $".."
	elif !ai:
		print("AI not found for ",self.name)
	
	for child in get_children():
		if child is MobState:
			states[child.name.to_lower()] = child
			child.Transitioned.connect(on_child_transition)
	
	if initial_state:
		initial_state.Initiate_Enter()
		current_state = initial_state


func _process(delta):
	if current_state:
		current_state.Initiate_Update(delta)


func _physics_process(delta):
	if current_state:
		current_state.Physics_Update(delta)
	
	
func on_child_transition(state, new_state_name):
	if state != current_state && state != ai:
		return
	
	var new_state = states.get(new_state_name.to_lower())
	if !new_state:
		return
	
	if current_state:
		current_state.Initiate_Exit()
		new_state.Initiate_Enter(current_state)
	else:
		new_state.Initiate_Enter()
	
	current_state = new_state
#	print(ai.name," entering ",current_state)
