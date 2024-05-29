@tool
class_name ParallaxPlus
extends Parallax2D


@export_category("ParallaxWizard")
enum Types {DEFAULT, HAZE, CLOUDS, SKY}
@export_range(-1.0, 1.0, 0.00001, "or_less", "or_greater") var distance : float = 0.0:
	set(value):
		if !ProjectSettings.get_setting("parallax_wizard/parallax/scroll_scale/xy_ratio"):
			#print("Parallax Wizard settings are not available. Activate the addon to use this feature.")
			return
		if distance == value:
			return
		if type == Types.CLOUDS:
			distance = 777.0
			return
		if type == Types.SKY:
			distance = 888.0
			return
		distance = clamp(value, -1.0, 1.0)
		_update_parallax_layer()
@export_enum("default", "haze", "clouds", "sky") var type : int = Types.DEFAULT:
	set(value):
		if !ProjectSettings.get_setting("parallax_wizard/parallax/scroll_scale/xy_ratio"):
			#print("Parallax Wizard settings are not available. Activate the addon to use this feature.")
			return
		if value == type:
			return
		type = value
		if type == Types.CLOUDS:
			distance = 777.0
		elif type == Types.SKY:
			distance = 888.0
		elif distance > 1.0:
			distance = 1.0
		_update_parallax_layer()

@onready var scroll_locked : bool = false


func _update_position(delta):
	if !scroll_locked:
		screen_offset = _calculate_screen_offset()
		if (verbose_in_editor && in_editor) || (verbose_in_game && !in_editor):
			print(self.name, " calculated screen_offset to be ", screen_offset)
	autoscroll_offset += autoscroll * delta
	autoscroll_offset = autoscroll_offset.posmodv(repeat_size)
	_update_scroll()


func _update_parallax_layer():
	if !Engine.is_editor_hint():
		return
	if !ProjectSettings.get_setting("parallax_wizard/parallax/scroll_scale/xy_ratio"):
		return
		
	_update_scroll_scale()
	
	if ProjectSettings.get_setting("parallax_wizard/parallax/z_indexes/set_automatically"):
		_update_z_index()


func _update_scroll_scale():
	var new : float
	if type == Types.SKY:
		new = ProjectSettings.get_setting("parallax_wizard/parallax/scroll_scale/sky")
		scroll_scale = Vector2(new, new)
		return
	elif type == Types.CLOUDS:
		new = ProjectSettings.get_setting("parallax_wizard/parallax/scroll_scale/clouds")
		scroll_scale = Vector2(new, new)
		return
	elif distance < 0:
		var max : float = ProjectSettings.get_setting("parallax_wizard/parallax/scroll_scale/foreground_max")
		new = lerpf(1.0, max, -distance)
	else:
		var min : float = ProjectSettings.get_setting("parallax_wizard/parallax/scroll_scale/background_min")
		new = lerpf(1.0, min, distance)
	scroll_scale = _adjust_scroll_scale_for_x_y(Vector2(new, new))


func _update_z_index():
	var new : int
	if type == Types.SKY:
		new = ProjectSettings.get_setting("parallax_wizard/parallax/z_indexes/sky")
	elif type == Types.CLOUDS:
		new = ProjectSettings.get_setting("parallax_wizard/parallax/z_indexes/clouds")
	elif distance < 0:
		new = lerp(int(ProjectSettings.get_setting("parallax_wizard/parallax/z_indexes/foreground_min")), int(ProjectSettings.get_setting("parallax_wizard/parallax/z_indexes/foreground_max")), -distance)
	else:
		new = lerp(int(ProjectSettings.get_setting("parallax_wizard/parallax/z_indexes/background_max")), int(ProjectSettings.get_setting("parallax_wizard/parallax/z_indexes/background_min")), distance)
	z_index = int(new)


func _adjust_scroll_scale_for_x_y(raw : Vector2) -> Vector2:
	var ms : Vector2
	var factor = ProjectSettings.get_setting("parallax_wizard/parallax/scroll_scale/xy_ratio")
	ms = (raw - Vector2.ONE) * factor + Vector2.ONE
	return ms


func _on_plugin_scroll_lock_toggled(value : bool):
	scroll_locked = value

func _on_plugin_scroll_lock_moved(p_screen_ofs):
	if follow_viewport:
		screen_offset = p_screen_ofs
