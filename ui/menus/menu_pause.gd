extends Control

var buttons: Array[Button]
var main: Main
var camera: Camera
var camera_animation: AnimationPlayer

func _ready() -> void:
	get_tree().paused = true
	#AnimationPlayer _camera_animation = _main.Player().TryGetChild<Camera2D>().TryGetChild<AnimationPlayer>();
	
	main = NodeExtention.get_child_by_script(NodeExtention.get_root(self), Main, true)
	buttons.assign(NodeExtention.get_children_by_classname(self, "Button"))
	camera = NodeExtention.get_child_by_script(NodeExtention.get_root(self), Camera, true)
	camera_animation = NodeExtention.get_child_by_classname(camera, "AnimationPlayer")
	camera_animation.play("zoom_out");
	
	# resume button
	buttons[0].grab_focus()
	buttons[0].pressed.connect(func():
		get_tree().paused = false
		camera_animation.play("zoom_in");
		self.queue_free()
		)
	
	# retry
	buttons[1].pressed.connect(func():
		get_tree().paused = false
		main.clear_scene()
		NodeExtention.instantiate(GameState.current_level.scene, main.world)
		)
	
	# level
	buttons[2].pressed.connect(func():
		get_tree().paused = false
		main.clear_scene()
		NodeExtention.instantiate(SceneLibrary.MENU_LEVEL, main.ui)
		)
	
	# main
	buttons[3].pressed.connect(func():
		get_tree().paused = false
		main.clear_scene()
		NodeExtention.instantiate(SceneLibrary.MENU_MAIN, main.ui)
		)
	
	# quit
	buttons[4].pressed.connect(func(): 
		NodeExtention.get_root(self).propagate_notification(Node.NOTIFICATION_WM_CLOSE_REQUEST)
		get_tree().quit()
		)

	return
