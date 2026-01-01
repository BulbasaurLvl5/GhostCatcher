extends Control

var buttons: Array[Button]
var main: Main
var level_container: VBoxContainer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	main = NodeExtention.get_child_by_script(NodeExtention.get_root(self), Main, true)
	level_container = NodeExtention.get_child_by_classname(self, "VBoxContainer", true)
	
	buttons.assign(NodeExtention.get_children_by_classname(self, "Button"))
	buttons[0].grab_focus()
	buttons[0].pressed.connect(func():
		main.clear_scene()
		NodeExtention.instantiate(SceneLibrary.MENU_MAIN, main.ui)
		)
	
	for level in SceneLibrary.levels:
		var menu_level_element = NodeExtention.instantiate(SceneLibrary.MENU_LEVEL_ELEMENT, level_container)
		
		var start_button: Button = NodeExtention.get_child_by_classname(menu_level_element, "Button")
		start_button.text = level.name
		start_button.pressed.connect(func():
			main.clear_scene()
			NodeExtention.instantiate(level.scene, main.world)
			)
			
		var labels: Array[Label]
		labels.assign(NodeExtention.get_children_by_classname(menu_level_element, "Label"))
		labels[0].text = "0.000" # replace with loaded last time
		labels[1].text = "0.600" # replace with loaded best time
		
		var rating_rect: TextureRect = NodeExtention.get_child_by_classname(menu_level_element, "TextureRect")
		match level.score(1): # replace with loaded times later
			0: rating_rect.texture = SceneLibrary.RATING_0
	pass
