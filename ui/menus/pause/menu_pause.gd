extends Control

var buttons: Array[Button]
#var main: Main
var camera: Camera
var camera_animation: AnimationPlayer

func _ready() -> void:
	get_tree().paused = true
	#AnimationPlayer _camera_animation = _main.Player().TryGetChild<Camera2D>().TryGetChild<AnimationPlayer>();
	
	#main = NodeExtention.get_child_by_type(NodeExtention.get_root(self), Main, true)
	buttons.assign(NodeExtention.get_children_by_type(self, "Button"))
	camera = NodeExtention.get_child_by_type(NodeExtention.get_root(self), Camera, true)
	camera_animation = NodeExtention.get_child_by_type(camera, "AnimationPlayer")
	camera_animation.play("zoom_out");
	
	# resume button
	buttons[0].grab_focus()
	buttons[0].pressed.connect(func():
		get_tree().paused = false
		camera_animation.play("zoom_in");
		Main.music.resume()
		self.queue_free()
		)
	
	# retry
	buttons[1].pressed.connect(func():
		get_tree().paused = false
		Main.clear_scene()
		NodeExtention.instantiate(Main.world, GameState.current_level.scene)
		)
	
	# level
	buttons[2].pressed.connect(func():
		get_tree().paused = false
		Main.clear_scene()
		NodeExtention.instantiate(Main.ui, SceneLibrary.MENU_LEVEL)
		)
	
	# Main
	buttons[3].pressed.connect(func():
		get_tree().paused = false
		Main.clear_scene()
		NodeExtention.instantiate(Main.ui, SceneLibrary.MENU_MAIN)
		)
	
	# quit
	buttons[4].pressed.connect(func(): 
		NodeExtention.get_root(self).propagate_notification(Node.NOTIFICATION_WM_CLOSE_REQUEST)
		get_tree().quit()
		)
	
	Main.music.stop()
	
	return
