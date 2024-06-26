class_name PlayerStateMachine
extends Node


@export var initial_state : PlayerState
@export var current_state : PlayerState

var states : Dictionary = {}

@onready var player : Player = $".."


func _ready():
	for child in get_children():
		if child is PlayerState:
			states[child.name.to_lower()] = child
			child.Transitioned.connect(on_child_transition)
	
	if initial_state:
		initial_state.Initiate_Enter()
		current_state = initial_state
		if player.verbose_state_changes:
			print("Player starting in ",current_state.name)


func _process(delta):
	if current_state:
		current_state.Initiate_Update(delta)


func _physics_process(delta):
	if current_state:
		current_state.Physics_Update(delta)
	if player.verbose_velocity:
		print("player_velocity = ", $"..".velocity)
	
func on_child_transition(_state, new_state_name):
#	if verbose:
#		print("Transition called from ",state.name," to ",new_state_name)
	#if state != current_state && state != $"..":
		#if player.verbose_state_changes:
			#print("Player state transition cancelled because ", state.name, " is not the current state.")
		#return
	
	var new_state = states.get(new_state_name.to_lower())
	if !new_state:
		return
	
	if player.verbose_state_changes:
		print("Player entering ", new_state.name)
	
	if current_state:
		current_state.Initiate_Exit()
		new_state.Initiate_Enter(current_state)
	else:
		new_state.Initiate_Enter()
	
	current_state = new_state
