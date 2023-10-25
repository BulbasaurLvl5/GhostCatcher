class_name PlayerState
extends Node

@export var player: Player
@export var anim: AnimationPlayer

@onready var fsm = $".." as PlayerStateMachine
@onready var idle_state = $"../PlayerIdleState"
@onready var move_state = $"../PlayerMoveState"
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
	
func _exit_state() -> void:
	print("exiting state")
