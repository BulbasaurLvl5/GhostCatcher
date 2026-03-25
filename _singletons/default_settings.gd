extends Node
"""
keeps references to the default project settings for menu resets

Saves on start:
	- default video options
	- default sound options
	- default input map
has to run before loading them (thus before settings_io)
"""

var vsync:int = DisplayServer.window_get_vsync_mode()
var window_mode:int = DisplayServer.window_get_mode()
var window_size:Vector2i = DisplayServer.window_get_size()

var volume_main:float = AudioServer.get_bus_volume_db(0)
var volume_effect:float = AudioServer.get_bus_volume_db(1)
var volume_music:float = AudioServer.get_bus_volume_db(2)
var volume_ui:float = AudioServer.get_bus_volume_db(3)

var controls:Dictionary[String, Array] = {}


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	print("default settings singleton loaded. It has a lokal runtime copy of the default settings.")
	
	for action in ControlExtention.get_my_actions():
		controls[action] = InputMap.action_get_events(action)
	
	return


func load_video() -> void:
	DisplayServer.window_set_vsync_mode(vsync)
	DisplayServer.window_set_size(window_size)
	
	if (window_mode == DisplayServer.WINDOW_MODE_FULLSCREEN):
		VideoExtention.set_full_screen()
	elif (window_mode == DisplayServer.WINDOW_MODE_WINDOWED):
		VideoExtention.set_window()
	return


func load_audio() -> void:
	AudioServer.set_bus_volume_db(0, volume_main)
	AudioServer.set_bus_volume_db(1, volume_effect)
	AudioServer.set_bus_volume_db(2, volume_music)
	AudioServer.set_bus_volume_db(3, volume_ui)
	return


func load_controls() -> void:
	for action in controls:
		InputMap.action_erase_events(action)
		for event in controls[action]:
			InputMap.action_add_event(action, event)
	return
