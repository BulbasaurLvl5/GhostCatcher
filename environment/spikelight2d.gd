class_name SpikeLight2D
extends PointLight2D


@export var cycle_duration_min : float = 1.0
@export var cycle_duration_max : float = 2.0

var current_cycle_duration : float
var time_in_cycle : float:
	set(value):
		if time_in_cycle == value:
			return
		time_in_cycle = value
		var relative_progress = time_in_cycle / current_cycle_duration
		if relative_progress < 0.5:
			energy = relative_progress * 2.0
		elif relative_progress < 1.0:
			energy = 1.0 - (relative_progress - 0.5) * 2.0
		else:
			time_in_cycle = 0.0
			reset_current_cycle()
			
@onready var rng = RandomNumberGenerator.new()


func _ready():
	reset_current_cycle()
	time_in_cycle = rng.randf() * current_cycle_duration
	

func _process(delta):
	time_in_cycle += delta
	
	
func reset_current_cycle():
	current_cycle_duration = lerpf(cycle_duration_min, cycle_duration_max, rng.randf())
