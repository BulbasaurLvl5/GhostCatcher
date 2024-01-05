class_name Camera
extends Camera2D


@export var max_distance : Vector2 = Vector2(500,300)
@export var max_zoom : float = .25
@export var zoom_out_duration = 2.5
@export var zoom_in_duration : float = 0.75
@export var toggle_zoom : bool = false

var zoom_is_active : bool = false
var zoom_start_position : float = 1
var current_zoom_duration : float = 0
var zoom_input_reset : bool = true

@export var default_shake_strength : float = 30.0
@export var shake_fade : float = 5.0

var rng = RandomNumberGenerator.new()
var shake_strength : float = 0.0


func _process(delta):
	var zoom_input : bool = false
	if Input.is_action_pressed("Zoom1") || Input.is_action_pressed("Zoom2"):
		zoom_input = true
		
	if !zoom_input_reset && !zoom_input:
		zoom_input_reset = true
	
	if toggle_zoom:
		if !zoom_is_active && zoom_input:
			camera_zoom(true, false)
		elif zoom_is_active && !zoom_input:
			camera_zoom(false, false)
	else:
		if zoom_input && zoom_input_reset:
			camera_zoom(false, true) 
			zoom_input_reset = false
			
	if shake_strength > 0:
		shake_strength = lerpf(shake_strength, 0, shake_fade * delta)
		
		offset = random_offset()


func _physics_process(delta):
	if zoom_is_active && zoom.x > max_zoom:
		zoom_out(delta)
	if !zoom_is_active && zoom.x < 1:
		zoom_in(delta)


func camera_zoom(activate : bool, toggle : bool = false):
	if toggle:
		if !zoom_is_active:
			set_zoom_out()
		else:
			set_zoom_in()
	elif activate:
		set_zoom_out()
	else:
		set_zoom_in()
	zoom_start_position = zoom.x		


func set_zoom_out():
	zoom_is_active = true
	current_zoom_duration = zoom_out_duration * (get_zoom().x - max_zoom) / (1 - max_zoom)


func set_zoom_in():
	zoom_is_active = false
	current_zoom_duration = zoom_in_duration * (1 - get_zoom().x) / (1 - max_zoom)


func zoom_out(delta : float):
	var new : Vector2 = get_zoom().lerp(Vector2(max_zoom, max_zoom), 2*delta/current_zoom_duration)
	set_zoom(new)
	
	
func zoom_in(delta : float):
	var new : Vector2 = get_zoom().lerp(Vector2.ONE, 2*delta/current_zoom_duration)
	set_zoom(new)


func apply_shake(shake_multiplier : float = 1.0):
	shake_strength = default_shake_strength * shake_multiplier

func random_offset() -> Vector2:
	return Vector2(rng.randf_range(-shake_strength,shake_strength), rng.randf_range(-shake_strength,shake_strength))
