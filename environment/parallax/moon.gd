class_name Moon
extends PathFollow2D


@export_range(0.0, 120.0, 0.0, "or_greater", "suffix:seconds") var event_length : float = 120.0
@onready var speed : float = 1.0 / event_length
var rng = RandomNumberGenerator.new()


func _ready():
	$"..".position.x += rng.randf_range(-1000, 1000)
#	if rng.randf_range(0.0, 1.0) >= 0.5:
#		$"..".scale.x *= -1.0


func _process(delta):
	progress_ratio += speed * delta
	if progress_ratio >= 1.0:
		queue_free()
