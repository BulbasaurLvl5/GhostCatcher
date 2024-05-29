class_name DeathShowsUp
extends Node2D


enum Scenes {first_meeting, getting_crows}
@export_enum("first_meeting", "getting_crows") var scene:
	set(value):
		scene = value
		if !death_node:
			return
		if scene == Scenes.first_meeting:
			death_node.position = Vector2(350, -500)
			death_node.quote_set = death_node.QUOTE_SETS.first_meeting
			death_node.quote_index = 0
			death_node.message_bubble_on = false
		elif scene == Scenes.getting_crows:
			death_node.position = Vector2(-350, -1500)
			death_node.quote_set = death_node.QUOTE_SETS.getting_crows
			death_node.quote_index = 0
			death_node.message_bubble_on = false
			
@export var death_node : Death

var player : Player
var encounter_started : bool = false
var dialogue_started : bool = false
var dialogue_finished : bool = false:
	set(value):
		if dialogue_finished == value:
			return
		dialogue_finished = value
		if dialogue_finished:
			if scene == Scenes.first_meeting:
				player.pan_camera(Vector2.ZERO, 3.0)
				await get_tree().create_timer(3.0).timeout
				player.toggle_camera_process(true)
			await get_tree().create_timer(0.25).timeout
			player.process_mode = Node.PROCESS_MODE_ALWAYS


func _process(_delta):
	if !dialogue_started || dialogue_finished:
		return
	if Input.is_action_just_pressed("Right1") || Input.is_action_just_pressed("Right2"):
		forward_dialogue()
	elif Input.is_action_just_pressed("Jump1") || Input.is_action_just_pressed("Jump2"):
		forward_dialogue()
	elif Input.is_action_just_pressed("Dash1") || Input.is_action_just_pressed("Dash2"):
		forward_dialogue()
	elif Input.is_action_just_pressed("ui_accept"):
		forward_dialogue()	


func forward_dialogue():
	if death_node.quote_index < death_node.current_quote_array.size() - 1:
		death_node.quote_index += 1
		if scene == Scenes.first_meeting && death_node.quote_index == 3:
			player.radar_enabled = true
		elif scene == Scenes.getting_crows && death_node.quote_index == 1:
			player.process_mode = Node.PROCESS_MODE_ALWAYS
			player.air_actions_enabled = true
			player.remaining_air_actions = 2
			player.process_mode = Node.PROCESS_MODE_DISABLED
	else:
		death_node.message_bubble_on = false
		dialogue_finished = true
		

func _on_area_2d_body_entered(body):
	if encounter_started || !body is Player:
		return
	player = body
	encounter_started = true
	if player.is_on_floor():
		on_player_landed()
	else:
		player.landed.connect(on_player_landed)
		
		
func on_player_landed():
	if player.landed.is_connected(on_player_landed):
		player.landed.disconnect(on_player_landed)
	player.process_mode = Node.PROCESS_MODE_DISABLED
	await get_tree().create_timer(1.0).timeout
	if scene == Scenes.first_meeting:
		player.toggle_camera_process(false)
		player.pan_camera(Vector2(500, 0), 1.0)
	elif scene == Scenes.getting_crows:
		death_node.death_moves(Vector2(-350, -100), 2.5)
		await get_tree().create_timer(2.5).timeout
	death_node.message_bubble_on = true
	dialogue_started = true
