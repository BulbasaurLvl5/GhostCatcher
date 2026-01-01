extends Node

var buttons: Array[Button]
var main: Main

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	main = NodeExtention.get_child_by_script(NodeExtention.get_root(self), Main, true)
	
	buttons.assign(NodeExtention.get_children_by_classname(self, "Button"))
	buttons[0].grab_focus()
	
	buttons[0].pressed.connect(func():
		main.clear_scene()
		NodeExtention.instantiate(SceneLibrary.MENU_LEVEL, main.ui)
		)
	
	buttons[1].pressed.connect(func():
		main.clear_scene()
		NodeExtention.instantiate(SceneLibrary.MENU_OPTIONS, main.ui)
		)
	
	buttons[2].pressed.connect(func(): 
		NodeExtention.get_root(self).propagate_notification(Node.NOTIFICATION_WM_CLOSE_REQUEST)
		get_tree().quit()
		)
	
	#_main.BackgroundMusic.CrossfadeTo(BackgroundMusic.SongNames.phantomx27);
	
	pass
