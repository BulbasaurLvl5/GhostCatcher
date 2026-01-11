extends Control


var buttons: Array[Button]
var main: Main
var player: Player


func _ready() -> void:
	get_tree().paused = true
	#AnimationPlayer _camera_animation = _main.Player().TryGetChild<Camera2D>().TryGetChild<AnimationPlayer>();
	
	main = NodeExtention.get_child_by_script(NodeExtention.get_root(self), Main, true)
	buttons.assign(NodeExtention.get_children_by_classname(self, "Button",true))
	player = NodeExtention.get_child_by_script(NodeExtention.get_root(self),Player,true)

	# retry
	buttons[0].grab_focus()
	buttons[0].pressed.connect(func():
		get_tree().paused = false
		main.clear_scene()
		NodeExtention.instantiate(GameState.current_level.scene, main.world)
		)

	# level
	buttons[1].pressed.connect(func():
		get_tree().paused = false
		main.clear_scene()
		NodeExtention.instantiate(SceneLibrary.MENU_LEVEL, main.ui)
		)
	
	# main
	buttons[2].pressed.connect(func():
		get_tree().paused = false
		main.clear_scene()
		NodeExtention.instantiate(SceneLibrary.MENU_MAIN, main.ui)
		)
	
	# quit
	buttons[3].pressed.connect(func(): 
		NodeExtention.get_root(self).propagate_notification(Node.NOTIFICATION_WM_CLOSE_REQUEST)
		get_tree().quit()
		)
	
	# move player 
	var screen_pos: Vector2 = player.get_global_transform_with_canvas().origin
	var player_animated_sprite: AnimatedSprite2D = NodeExtention.get_child_by_classname(player, "AnimatedSprite2D")
	if(player_animated_sprite): # for unknown reasons this sometimes crashes the game when pressing retry in menu
		player_animated_sprite.reparent(self)
		player_animated_sprite.position = screen_pos
	
	var center: Vector2 = get_viewport().get_visible_rect().size * .5;
	var tween: Tween = create_tween()
	tween.tween_property(player_animated_sprite, 
		"position", 
		Vector2(center.x, center.y+220), 
		1).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT).set_delay(1)
		
	# save data + manage menu on success
	if(GameState.level_success):
		var idx: int = GameState.current_level_idx()
		FileIo.save_time(FileIO.SaveFileKeys.LAST_TIMES, idx, GameState.level_time)
		
		var time_labels: Array[Label]
		time_labels.assign(NodeExtention.get_children_by_classname(self,"Label",true))
		time_labels[0].text = Clock.float_to_string(GameState.level_time)
		
		var save_file: FileIO.SaveFile = FileIo.load_file()
		time_labels[1].text = Clock.float_to_string(save_file.best_times[idx])
		
		var rating_rect: TextureRect = NodeExtention.get_child_by_classname(self,"TextureRect",true)
		
		# new best
		if(save_file.best_times[idx] == 0 ||
				GameState.level_time < save_file.best_times[idx]):
			save_file.best_times[idx] = GameState.level_time
			FileIo.save_time(FileIO.SaveFileKeys.BEST_TIMES, idx, GameState.level_time)
			time_labels[1].text = Clock.float_to_string(GameState.level_time)
			
			var old_size = time_labels[1].label_settings.font_size
			var tween_size: Tween = create_tween()
			var tween_modulate: Tween = create_tween()
			time_labels[1].label_settings.font_size = 600
			modulate.a = 0
			tween_size.tween_property(time_labels[1].label_settings, "font_size", old_size, 1.5).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
			tween_modulate.tween_property(self, "modulate:a", 1.0, 0.5).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
			
			rating_rect.modulate = Color(1, 1, 1, 1)

		for i in GameState.current_level.score(GameState.level_time)+1:
			await get_tree().create_timer(.5).timeout
			rating_rect.texture = SceneLibrary.RATING[i]
			
	else:
		get_child(2).visible = false # ratings and labels
