extends Control


var buttons: Array[Button]
var options: Array[GridContainer]
#var main: Main


func _ready() -> void:
	#main = NodeExtention.get_child_by_type(NodeExtention.get_root(self), Main, true)
	
	options.assign(NodeExtention.get_children_by_type(self, "GridContainer"))
	buttons.assign(NodeExtention.get_children_by_type(self, "Button"))
	buttons[0].grab_focus()
	
	# back
	buttons[0].pressed.connect(func():
		Main.clear_scene()
		NodeExtention.instantiate(Main.ui, SceneLibrary.MENU_MAIN)
		)
	
	# Video
	buttons[1].focus_entered.connect(func():
			options[0].show()
			options[1].hide()
			options[2].hide()
			)

	# Audio
	buttons[2].focus_entered.connect(func():
			options[0].hide()
			options[1].show()
			options[2].hide()
			)

	# Ctrls
	buttons[3].focus_entered.connect(func():
			options[0].hide()
			options[1].hide()
			options[2].show()
			)
	
	Main.music.cross_fade_to(Music.SONG_MENU, 1, 1, true)
	EnergySaver.set_max_fps(30)
	
	return
