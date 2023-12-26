class_name DashGhost
extends AnimatedSprite2D

func _ready():
	ghosting()

func set_property(g_frame, g_position, g_scale):
	set_frame(g_frame)
	set_position(g_position)
	set_scale(g_scale)
	
func ghosting():
	var tween_fade = get_tree().create_tween()
	
	tween_fade.tween_property(self,"self_modulate",Color(1, 1, 1, 0),0.75)
	await tween_fade.finished
	
	queue_free()
