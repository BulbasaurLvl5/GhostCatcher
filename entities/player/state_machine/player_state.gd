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
	
	
func Initiate_Enter(from : PlayerState = null):
	data = player.data
	verbose = player.verbose
	if verbose:
		if from:
			print("Transitioning from ",from.name," to ",self.name)
		else:
			print("Entering ",self.name)
	time_in_current_state = 0
	Enter(from)
	
	
func Enter(_from : PlayerState):
	pass
	
	
func Initiate_Update(delta):
	time_in_current_state += delta
	Do_Checks()
	Update(delta)
	
	
func Do_Checks():
	pass
	
func Update(_delta):
	pass
	
	
func Physics_Update(_delta):
	pass


func Initiate_Exit():
	Exit()
	

func Exit():
	pass


func Flip_Player(force_flip : bool = false) -> bool:
	if force_flip || (player.facing_direction != player.x_input && abs(player.x_input) == 1):
		player.facing_direction *= -1
		anim.scale.x *= -1
		%RayCasts.scale.x *= -1
		return true
	return false
		
		
func Check_Altitude():
	if player.position.y < player.height_fallen_from:
		player.height_fallen_from = player.position.y	
		
		
func Grounded_Gravity(delta : float):
	if player.moving_platform:
		if player.moving_platform is MovingTileMap:
			player.velocity = (player.moving_platform.global_position - player.stored_wall_pos) / delta
			player.stored_wall_pos = player.moving_platform.global_position
		player.velocity.y = max(player.velocity.y, data.gravity)
	else:
		player.velocity.y = max(player.velocity.y, data.gravity * delta)
