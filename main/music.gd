class_name Music
extends Node

static var SONG_MENU := preload("uid://dtuy4keqtn2ro")
static var SONG_LEVEL := preload("uid://bnr2eyxtgsd28")

var _channel_1:AudioStreamPlayer
var _channel_2:AudioStreamPlayer
var _channel_active:AudioStreamPlayer
var _channel_inactive:AudioStreamPlayer

var tween_fade_out:Tween
var tween_fade_in:Tween


func _ready() -> void:
	var asp := NodeExtention.get_children_by_type(self, "AudioStreamPlayer")
	_channel_1 = asp[0]
	_channel_2 = asp[1]
	
	_channel_1.bus = "Music"
	_channel_2.bus = "Music"
	
	_channel_active = _channel_1
	_channel_active.volume_db = 0
	
	_channel_inactive = _channel_2
	_channel_inactive.volume_db = -80
	
	return


func play(song:AudioStreamMP3) -> void:
	_channel_active.stream = song
	_channel_active.play()
	_channel_active.volume_db = 0
	
	_channel_inactive.stop()
	_channel_inactive.volume_db = -80
	return


func stop() -> void:
	_channel_active.stop()
	return


func resume() -> void:
	_channel_active.play()
	return


func cross_fade_to(song:AudioStreamMP3, fade_out_time:float = 1.0, fade_in_time:float = 1.0, skip_if_alredy_playing = false) -> void:
	
	# skip if song is already playing, e.g. in menus
	if(skip_if_alredy_playing and song == _channel_active.stream):
		return
	
	if tween_fade_out and tween_fade_out.is_running():
		tween_fade_out.kill()
	if tween_fade_in and tween_fade_in.is_running():
		tween_fade_in.kill()
	
	tween_fade_out = create_tween()
	tween_fade_out.tween_property(_channel_active, "volume_db", -80.0, fade_out_time)
	#tween_fade_out.tween_callback(_channel_active.stop) # can cause trouble when called faster than fade out
		
	tween_fade_in = create_tween()
	_channel_inactive.stream = song
	_channel_inactive.play()
	tween_fade_in.tween_property(_channel_inactive, "volume_db", 0, fade_in_time)
	
	var temp := _channel_active
	_channel_active = _channel_inactive
	_channel_inactive = temp 
	return
