class_name PlayerState
extends Node

@export var player: Player
@export var anim: AnimationPlayer

@onready var fsm = $".." as PlayerStateMachine
@onready var idle_state = $"../PlayerIdleState"
@onready var walk_state = $"../PlayerWalkState"
@onready var run_state = $"../PlayerRunState"
@onready var jump_state = $"../PlayerJumpState"
@onready var in_air_state = $"../PlayerInAirState"
@onready var land_state = $"../PlayerLandState"
@onready var die_state = $"../PlayerDieState"

signal state_finished

func _ready():
	player = $"../.."
	anim = $"../../PlayerSprite2D/PlayerAnimation"

func _enter_state() -> void:
	print("entering state")
	player.is_exiting_state = false
	
func _exit_state() -> void:
	print("exiting state")
	
	
func player_move_states():
	if Input.is_action_pressed("Run"):
		fsm.change_state(run_state)
	else:
		fsm.change_state(walk_state)

func _process(delta):
	if !player.is_exiting_state:
		_do_checks(delta)

func _do_checks(delta):
	pass
