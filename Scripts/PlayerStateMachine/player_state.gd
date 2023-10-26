class_name PlayerState
extends Node

signal Transitioned

@export var player: Player
@export var anim: AnimationPlayer

#borrows verbose setting from Player
@onready var verbose: bool = $"../..".verbose

var time_in_current_state = 0

func _ready():
	player = $"../.."
	anim = $"../../PlayerSprite2D/PlayerAnimation"
	
func Transition():
	if verbose:
		print("Entering ",self.name)
	time_in_current_state = 0
	Enter()

func Enter():
	pass
	
func Exit():
	pass

func Initiate_Update(delta):
	time_in_current_state += delta
	Flip_Player()
	Do_Checks()
	Update(delta)
	
func Do_Checks():
	pass
	
func Update(delta):
	pass
	
func Physics_Update(delta):
	pass

func Flip_Player():
	if player.facing_direction != player.x_input && abs(player.x_input) == 1:
		player.facing_direction = player.x_input
		player.scale.x *= -1
	
func Walk_Or_Run(current_state: PlayerState):
	if Input.is_action_pressed("Slow"):
		Transitioned.emit(current_state,"Walk")
	else:
		Transitioned.emit(current_state,"Run")
