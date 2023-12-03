class_name PlayerState
extends Node

signal Transitioned

@export var player : Player
@export var anim : AnimatedSprite2D

@onready var data : PlayerDataResource
@onready var verbose : bool 

@onready var time_in_current_state = 0


func _ready():
	player = $"../.."
	anim = $"../../PlayerAnimatedSprite2D"
	
	
func Transition():
	data = player.data
	verbose = player.verbose
	if verbose:
		print("Entering ",self.name)
	time_in_current_state = 0
	Enter()


func Enter():
	data = player.data
	verbose = player.verbose


func Initiate_Update(delta):
	time_in_current_state += delta
	Flip_Player()
	Do_Checks()
	Update(delta)
	
	
func Do_Checks():
	pass
	
func Update(_delta):
	pass
	
func Physics_Update(_delta):
	pass


func Flip_Player():
	if player.facing_direction != player.x_input && abs(player.x_input) == 1:
		player.facing_direction *= -1
		$"../../PlayerAnimatedSprite2D".scale.x *= -1
	
	
func Walk_Or_Run(current_state: PlayerState):
	if Input.is_action_pressed("Slow"):
		Transitioned.emit(current_state,"Walk")
	else:
		Transitioned.emit(current_state,"Run")

