@tool
class_name ParallaxWizardSettings
extends Control

signal restore_defaults()


func _ready():
	if !Engine.is_editor_hint():
		return
	load_button_data_from_settings()


func load_button_data_from_settings():
	%CheckBox_AutomaticConvert.button_pressed = ProjectSettings.get_setting("parallax_wizard/parallax/automatically_convert_parallax_nodes", false)
	%SpinBox_FGScrollMax.value = ProjectSettings.get_setting("parallax_wizard/parallax/scroll_scale/foreground_max", 1.25)
	%SpinBox_BGScrollMin.value = ProjectSettings.get_setting("parallax_wizard/parallax/scroll_scale/background_min", 0.1)
	%SpinBox_CloudsScrollScale.value = ProjectSettings.get_setting("parallax_wizard/parallax/scroll_scale/clouds", 0.05)
	%SpinBox_SkyScrollScale.value = ProjectSettings.get_setting("parallax_wizard/parallax/scroll_scale/sky", 0.01)
	var motion_scale_factor = ProjectSettings.get_setting("parallax_wizard/parallax/scroll_scale/xy_ratio", Vector2(1.0, 0.5))
	%SpinBox_ScrollScaleX.value = motion_scale_factor.x
	%SpinBox_ScrollScaleY.value = motion_scale_factor.y
	var auto_z_indexes = ProjectSettings.get_setting("parallax_wizard/parallax/z_indexes/set_automatically", true)
	%CheckBox_AutomaticZ.button_pressed = auto_z_indexes
	show_z_indexes(auto_z_indexes)
	%SpinBox_FGZMin.value = ProjectSettings.get_setting("parallax_wizard/parallax/z_indexes/foreground_max", 1000)
	%SpinBox_FGZMax.value = ProjectSettings.get_setting("parallax_wizard/parallax/z_indexes/foreground_min", 11)
	%SpinBox_BGZMin.value = ProjectSettings.get_setting("parallax_wizard/parallax/z_indexes/background_max", -11)
	%SpinBox_BGZMax.value = ProjectSettings.get_setting("parallax_wizard/parallax/z_indexes/background_min", -1000)
	%SpinBox_CloudsZ.value = ProjectSettings.get_setting("parallax_wizard/parallax/z_indexes/clouds", -1001)
	%SpinBox_SkyZ.value = ProjectSettings.get_setting("parallax_wizard/parallax/z_indexes/sky", -2000)


func show_z_indexes(active : bool = true):
	%Grid_Z.visible = active


func save_settings():
	var error : int = ProjectSettings.save()
	if error:
		push_error("Encountered error %d when saving project settings." % error)


func _on_check_box_automatic_convert_toggled(toggled_on):
	ProjectSettings.set_setting("parallax_wizard/parallax/automatically_convert_parallax_nodes", toggled_on)
	save_settings()

func _on_spin_box_fg_scroll_max_value_changed(value):
	ProjectSettings.set_setting("parallax_wizard/parallax/scroll_scale/foreground_max", value)
	save_settings()

func _on_spin_box_bg_scroll_min_value_changed(value):
	ProjectSettings.set_setting("parallax_wizard/parallax/scroll_scale/background_min", value)
	save_settings()

func _on_spin_box_clouds_scroll_scale_value_changed(value):
	ProjectSettings.set_setting("parallax_wizard/parallax/scroll_scale/clouds", value)
	save_settings()
	
func _on_spin_box_sky_scroll_scale_value_changed(value):
	ProjectSettings.set_setting("parallax_wizard/parallax/scroll_scale/sky", value)
	save_settings()

func _on_spin_box_scroll_scale_x_value_changed(value):
	ProjectSettings.set_setting("parallax_wizard/parallax/scroll_scale/xy_ratio", Vector2(value, ProjectSettings.get_setting("parallax_wizard/parallax/scroll_scale/xy_ratio").y))
	save_settings()

func _on_spin_box_scroll_scale_y_value_changed(value):
	ProjectSettings.set_setting("parallax_wizard/parallax/scroll_scale/xy_ratio", Vector2(ProjectSettings.get_setting("parallax_wizard/parallax/scroll_scale/xy_ratio").x, value))
	save_settings()

func _on_check_box_automatic_z_toggled(toggled_on):
	ProjectSettings.set_setting("parallax_wizard/parallax/z_indexes/set_automatically", toggled_on)
	save_settings()
	show_z_indexes(toggled_on)

func _on_spin_box_fgz_max_value_changed(value):
	ProjectSettings.set_setting("parallax_wizard/parallax/z_indexes/foreground_max", value)
	save_settings()

func _on_spin_box_fgz_min_value_changed(value):
	ProjectSettings.set_setting("parallax_wizard/parallax/z_indexes/foreground_min", value)
	save_settings()

func _on_spin_box_bgz_max_value_changed(value):
	ProjectSettings.set_setting("parallax_wizard/parallax/z_indexes/background_max", value)
	save_settings()

func _on_spin_box_bgz_min_value_changed(value):
	ProjectSettings.set_setting("parallax_wizard/parallax/z_indexes/background_min", value)
	save_settings()

func _on_spin_box_clouds_z_value_changed(value):
	ProjectSettings.set_setting("parallax_wizard/parallax/z_indexes/clouds", value)
	save_settings()

func _on_spin_box_sky_z_value_changed(value):
	ProjectSettings.set_setting("parallax_wizard/parallax/z_indexes/sky", value)
	save_settings()

func _on_button_restore_default_pressed():
	restore_defaults.emit()

func _on_button_exit_pressed():
	queue_free()
