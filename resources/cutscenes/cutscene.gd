class_name Cutscene
extends Node


var player : Player
var standin_anim : AnimatedSprite2D
var standin_velocity : Vector2 = Vector2.ZERO

var moving_standin : bool = false
var standin_destination : Vector2


func _ready():
	find_player()


func _process(delta):
	if !player:
		find_player()
	if moving_standin:
		if %standin.position.distance_to(standin_destination) <= Vector2.ZERO.distance_to(standin_velocity * delta):
			%standin.position = standin_destination
			standin_velocity = Vector2.ZERO
			moving_standin = false
		else:
			%standin.position += standin_velocity * delta


func find_player():
	if player:
		return
	#var nodes = $"../../../../World".get_children()
	var allchildren = get_tree().root.get_children()
	var children = []
	
	while len(allchildren) > 0:
		var temp = []
		for c in allchildren:
			print(c)
			temp.append(c)
			temp.append(c.get_children())
			allchildren.append(temp)
			allchildren.erase(c)
			
			if c is Player:
				player = c
				break
		children.append(temp)
	
	for n in children:
		if n is Player:
			player = n
			break
	if player:
		copy_player_image()
	#else:
		#print("player not yet found")


func copy_player_image():
	standin_anim = %standin.find_child("AnimatedSprite2D")
	var player_anim = player.find_child("PlayerAnimatedSprite2D")
	var camera = player.find_child("Camera2D")
	var fov = camera.field_of_view_multiplier
	%standin.position = (player.position - camera.get_screen_center_position()) / fov + Vector2(960, 540)
	standin_anim.scale = player_anim.scale * Vector2.ONE / Vector2(fov, fov)
	standin_anim.speed_scale = 0.0
	standin_anim.animation = player_anim.animation
	standin_anim.frame = player_anim.frame
	%standin.visible = true
	player_anim.visible = false
	%cutscenes.play("dead")


func timed_float_player_to(target : Vector2, time : float):
	if !player:
		find_player()
	standin_destination = target
	standin_velocity = (target - %standin.position) / time
	moving_standin = true
