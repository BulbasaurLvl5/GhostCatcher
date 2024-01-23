class_name StompShockwave
extends Area2D


@export_range(0.0, 5.0, 0.0, "or_greater", "suffix:seconds") var shockwave_duration : float = 1.0
@export_range(0.0, 500.0, 0.0, "or_greater", "suffix:pixels") var scale_multiplier : float = 50.0

@onready var duration_remaining : float = shockwave_duration
@onready var final_scale : Vector2 = scale * scale_multiplier

var shocked_mobs : Array[MobAI]


func _ready():
	var tween_scale = get_tree().create_tween()
	var tween_fade = get_tree().create_tween()
	tween_scale.tween_property(self, "scale", final_scale, shockwave_duration)
	tween_fade.tween_property(self, "modulate", Color(1, 1, 1, 0), shockwave_duration)
	await tween_fade.finished
	queue_free()


#func _on_area_entered(area):
##	print("AREA detected by shockwave")
#	if area is MobAI && !shocked_mobs.has(area):
##		print("AREA identified as MobAI")
#		area.Knockback(position)
#		shocked_mobs.append(area)


func _on_body_entered(body):
	if body is MobAI && !shocked_mobs.has(body):
#		print("AREA identified as MobAI")
		body.Knockback(position)
		shocked_mobs.append(body)
