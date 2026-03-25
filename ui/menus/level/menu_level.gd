extends Node

var buttons: Array[Button]
#var main: Main
var level_container: VBoxContainer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#main = NodeExtention.get_child_by_type(NodeExtention.get_root(self), Main, true)
	level_container = NodeExtention.get_child_by_type(self, "VBoxContainer", true)
	
	buttons.assign(NodeExtention.get_children_by_type(self, "Button"))
	buttons[0].grab_focus()
	buttons[0].pressed.connect(func():
		Main.clear_scene()
		NodeExtention.instantiate(Main.ui, SceneLibrary.MENU_MAIN)
		)
		
	var save_file: FileIO.SaveFile = FileIo.load_file()
	
	for level in SceneLibrary.levels:
		var idx: int = SceneLibrary.levels.find(level)
		var menu_level_element = NodeExtention.instantiate(level_container, SceneLibrary.MENU_LEVEL_ELEMENT)
		
		var start_button: Button = NodeExtention.get_child_by_type(menu_level_element, "Button")
		start_button.text = level.name
		start_button.pressed.connect(func():
			Main.clear_scene()
			NodeExtention.instantiate(Main.world, level.scene)
			GameState.current_level = level
			)
			
		var labels: Array[Label]
		labels.assign(NodeExtention.get_children_by_type(menu_level_element, "Label"))
		labels[0].text = Clock.float_to_string(save_file.last_times[idx])
		labels[1].text = Clock.float_to_string(save_file.best_times[idx])
		
		var rating_rect: TextureRect = NodeExtention.get_child_by_type(menu_level_element, "TextureRect")
		match level.score(save_file.best_times[idx]): # replace with loaded times later
			0: rating_rect.texture = SceneLibrary.RATING[0]
			1: rating_rect.texture = SceneLibrary.RATING[1]
			2: rating_rect.texture = SceneLibrary.RATING[2]
			3: rating_rect.texture = SceneLibrary.RATING[3]
			4: rating_rect.texture = SceneLibrary.RATING[4]
			5: rating_rect.texture = SceneLibrary.RATING[5]
	
	Main.music.cross_fade_to(Music.SONG_MENU, 1, 1, true)
	EnergySaver.set_max_fps(30)
	
	return
