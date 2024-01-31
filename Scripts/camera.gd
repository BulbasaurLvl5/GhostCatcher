class_name Camera
extends Camera2D

signal Zoomed(new_zoom_setting : Vector2)


@export_group("Zoom")
@export_range (0.0, 1.0, 0.0, "suffix:X") var max_zoom_out : float = .25
#Smaller numbers bring the camera away from the action.

@export_range (1.0, 64.0, 0.0, "suffix:X") var max_zoom_in_not_used_yet : float = 1.0
#Larger numbers move the camera towards the action.

@export_range (0.0, 10.0, 0.0, "or_greater", "suffix:seconds") var zoom_out_duration : float = 2.5
@export_range (0.0, 10.0, 0.0, "or_greater", "suffix:seconds") var zoom_reset_duration : float = 0.75
@export var sticky_zoom : bool = true
#Zooming will stop whenever the player releases the button.
#Overrides toggled_zoom if both are activated.

@export var toggled_zoom : bool = false
#Zooms all the way in or out with each button press.
#Overridden by sticky_zoom if both are activated.

@export_group("Shake")
@export_range (0.0, 128.0, 0.0, "or_greater", "suffix:pixels maximum") var default_shake_strength : float = 32.0
@export_range (0.0, 16.0, 0.0, "or_greater", "suffix:pixels per second") var default_shake_fade : float = 5.0

#ZOOM
var zoom_input : bool = false
var zoom_input_reset : bool = true
var zoom_direction : int = 0
var current_zoom_duration : float = 0
var zoom_is_changing : bool = false

#SHAKE
var rng = RandomNumberGenerator.new()
var shake_strength : float = 0.0

var level_boundary : Rect2
var boundary_updated : bool = false


func _ready():
	boundary_updated = false
	enable_smooth_and_drag(false)
	position = Vector2(0, -200)
	find_level_boundary()
	

func find_level_boundary():
	var level_data : LevelData = get_tree().root.find_child("LvlData", true, false)
	if level_data:
		limit_top = int(level_data.top_boundary * -110)
		limit_left = int(level_data.left_boundary * -110)
		limit_right = int(level_data.right_boundary * 110.0)
		limit_bottom = int(level_data.bottom_boundary * 110.0)
#		print("Boundary = ",limit_left, limit_top, limit_right, limit_bottom)
		$"..".set_level_boundary(limit_top, limit_left, limit_right, limit_bottom)
		boundary_updated = true


func enable_smooth_and_drag(enable : bool = true):
	position_smoothing_enabled = enable
	drag_horizontal_enabled = enable
	drag_vertical_enabled = enable
	

#PROCESS
func _process(delta):
	if !boundary_updated:
		find_level_boundary()
	if !position_smoothing_enabled:
		enable_smooth_and_drag(true)
		position = Vector2.ZERO
	zoom_input = get_zoom_input()
	if sticky_zoom || toggled_zoom:
		check_sticky_and_toggled()
	else:
		check_manual()
	
	if zoom_is_changing && !zoom_is_at_limit():
		var new : Vector2 = Vector2.ZERO 
		if zoom_direction == 1:
			new = get_zoom().lerp(Vector2.ONE, 2*delta/current_zoom_duration)
		else:
			new = get_zoom().lerp(Vector2(max_zoom_out, max_zoom_out), 2*delta/current_zoom_duration)
		set_zoom(new)
		Zoomed.emit(new)
#SHAKE
	if shake_strength > 0:
		shake_strength = lerpf(shake_strength, 0, default_shake_fade * delta)
		offset = random_offset()
	else:
		offset = Vector2.ZERO

#ZOOM
func get_zoom_input():
	if Input.is_action_pressed("Zoom1") || Input.is_action_pressed("Zoom2"):
		return true
	else:
		zoom_input_reset = true
		return false

func check_sticky_and_toggled():
	if zoom_input:
		if zoom_input_reset:
			if zoom_direction == -1:
				set_zoom_in()
			else:
				set_zoom_out()
			zoom_input_reset = false
	elif sticky_zoom:
		zoom_is_changing = false
		
func check_manual():
	if zoom_input:
		if zoom_input_reset:
			set_zoom_out()
			zoom_input_reset = false
	elif zoom_direction < 1:
		set_zoom_in()

func set_zoom_out():
	zoom_is_changing = true
	zoom_direction = -1
	current_zoom_duration = zoom_out_duration * (get_zoom().x - max_zoom_out) / (1 - max_zoom_out)

func set_zoom_in():
	zoom_is_changing = true
	zoom_direction = 1
	current_zoom_duration = zoom_reset_duration * (1 - get_zoom().x) / (1 - max_zoom_out)

func zoom_is_at_limit() -> bool:
	if zoom_direction == 1 && get_zoom() >= Vector2.ONE:
		return true
	if zoom_direction == -1 && get_zoom().x <= max_zoom_out:
		return true
	else:
		return false
		
#SHAKE
func apply_shake(shake_multiplier : float = 1.0):
	shake_strength = default_shake_strength * shake_multiplier

func random_offset() -> Vector2:
	return Vector2(rng.randf_range(-shake_strength,shake_strength), rng.randf_range(-shake_strength,shake_strength))
