class_name PlayerState
extends Node

signal Transitioned

@export var player: Player
@export var anim: AnimationPlayer


#@onready var fsm = $".." as PlayerStateMachine
#@onready var idle_state = $"../PlayerIdleState"
#@onready var walk_state = $"../PlayerWalkState"
#@onready var run_state = $"../PlayerRunState"
#@onready var jump_state = $"../PlayerJumpState"
#@onready var in_air_state = $"../PlayerInAirState"
#@onready var land_state = $"../PlayerLandState"
#@onready var die_state = $"../PlayerDieState"
#
#signal state_finished
#
func _ready():
	player = $"../.."

	anim = $"../../PlayerSprite2D/PlayerAnimation"

func Enter():
	Do_Checks()
	
func Exit():
	pass
	
func Update():
	Do_Checks()
	
func Physics_Update():
	pass

func Do_Checks():
	pass
	
func player_move_states(current_state: PlayerState):
	if Input.is_action_pressed("Run"):
		Transitioned.emit(current_state,"Run")
	else:
		Transitioned.emit(current_state,"Walk")

#func _process(delta):
#	if !player.is_exiting_state:
#		_do_checks(delta)


