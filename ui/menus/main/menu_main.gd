extends Node

var buttons: Array[Button]
#var main: Main

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	
	buttons.assign(NodeExtention.get_children_by_type(self, "Button"))
	buttons[0].grab_focus()
	
	buttons[0].pressed.connect(func():
		Main.clear_scene()
		NodeExtention.instantiate(Main.ui, SceneLibrary.MENU_LEVEL)
		)
	
	buttons[1].pressed.connect(func():
		Main.clear_scene()
		NodeExtention.instantiate(Main.ui, SceneLibrary.MENU_OPTIONS)
		)
	
	buttons[2].pressed.connect(func(): 
		NodeExtention.get_root(self).propagate_notification(Node.NOTIFICATION_WM_CLOSE_REQUEST)
		get_tree().quit()
		)
	
	Main.music.cross_fade_to(Music.SONG_MENU, 1, 1, true)
	EnergySaver.set_max_fps(30)
	
	pass
