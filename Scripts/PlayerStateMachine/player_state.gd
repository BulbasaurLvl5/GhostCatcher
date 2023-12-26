class_name PlayerState
extends Node

signal Transitioned

var player : Player
var anim : AnimatedSprite2D
var sfx : Node

@onready var data : PlayerDataResource
@onready var verbose : bool 
@onready var time_in_current_state = 0


func _ready():
	player = $"../.."
	anim = %PlayerAnimatedSprite2D
	sfx = %SFX
	
	
func Transition():
	data = player.data
	verbose = player.verbose
	if verbose:
		print("Entering ",self.name)
	time_in_current_state = 0
#	if verbose:
#		print("shape_cast offset = ",%ShapeCast2D.position)	
	Enter()


func Enter():
	pass


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
		anim.scale.x *= -1
