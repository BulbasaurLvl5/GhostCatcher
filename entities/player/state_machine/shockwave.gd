class_name Shockwave
extends Area2D


@export_range(0.0, 5.0, 0.001, "or_greater", "suffix:seconds") var shockwave_duration : float = 1.0
@export_range(0.0, 500.0, 0.001, "or_greater", "suffix:pixels") var scale_multiplier : float = 50.0

@onready var duration_remaining : float = shockwave_duration
@onready var final_scale : Vector2 = scale * scale_multiplier
@onready var facing_direction : int = 1

var start_signal = false
var shocked_mobs : Array[MobAI]
var motion : Vector2 = Vector2.ZERO


func start():
	var tween_scale = get_tree().create_tween()
	var tween_fade = get_tree().create_tween()
	tween_scale.tween_property(self, "scale", Vector2(final_scale.x * facing_direction, final_scale.y), shockwave_duration)
	tween_fade.tween_property(self, "modulate", Color(1, 1, 1, 0), shockwave_duration)
	await tween_fade.finished
	queue_free()


func _physics_process(delta):
	if motion != Vector2.ZERO:
		position += motion * delta


func _on_body_entered(body):
	if body is MobAI && !shocked_mobs.has(body):
		body.Knockback(position)
		shocked_mobs.append(body)
