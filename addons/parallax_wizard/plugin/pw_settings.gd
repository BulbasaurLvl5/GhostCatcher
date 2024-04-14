@tool
class_name ParallaxWizardSettings
extends Control

signal restore_defaults()


func _ready():
	if !Engine.is_editor_hint():
		return
	load_button_data_from_settings()


func load_button_data_from_settings():
	%CheckBox_AutomaticConvert.button_pressed = ProjectSettings.get_setting("parallax_wizard/parallax/automatic_convert", true)
	%CheckBox_PositionWhenScaling.button_pressed = ProjectSettings.get_setting("parallax_wizard/parallax/preserve_positions_when_scaling", true)
	%SpinBox_FGMotionMax.value = ProjectSettings.get_setting("parallax_wizard/parallax/motion_scale/foreground_motion_scale_max", 1.25)
	%SpinBox_BGMotionMin.value = ProjectSettings.get_setting("parallax_wizard/parallax/motion_scale/background_motion_scale_min", 0.1)
	%SpinBox_CloudMotionScale.value = ProjectSettings.get_setting("parallax_wizard/parallax/motion_scale/cloud_motion_scale", 0.05)
	%SpinBox_StarMotionScale.value = ProjectSettings.get_setting("parallax_wizard/parallax/motion_scale/star_motion_scale", 0.01)
	var motion_scale_factor = ProjectSettings.get_setting("parallax_wizard/parallax/motion_scale/motion_scale_factor", Vector2(1.0, 0.5))
	%SpinBox_MotionScaleX.value = motion_scale_factor.x
	%SpinBox_MotionScaleY.value = motion_scale_factor.y
	var auto_z_values = ProjectSettings.get_setting("parallax_wizard/parallax/z_indexes/automatic_z_indexes", true)
	%CheckBox_AutomaticZValues.button_pressed = auto_z_values
	show_z_indexes(auto_z_values)
	%SpinBox_FGZMin.value = ProjectSettings.get_setting("parallax_wizard/parallax/z_indexes/foreground_z_index_min", -1000)
	%SpinBox_FGZMax.value = ProjectSettings.get_setting("parallax_wizard/parallax/z_indexes/foreground_z_index_max", -11)
	%SpinBox_BGZMin.value = ProjectSettings.get_setting("parallax_wizard/parallax/z_indexes/background_z_index_min", 11)
	%SpinBox_BGZMax.value = ProjectSettings.get_setting("parallax_wizard/parallax/z_indexes/background_z_index_max", 1000)
	%SpinBox_CloudZ.value = ProjectSettings.get_setting("parallax_wizard/parallax/z_indexes/cloud_z_index", 1001)
	%SpinBox_StarZ.value = ProjectSettings.get_setting("parallax_wizard/parallax/z_indexes/star_z_index", 2000)
	var use_custom_script = ProjectSettings.get_setting("parallax_wizard/parallax/movement_script/use_custom_script", false)
	if use_custom_script:
		%OptionButton_MotionScript.selected = 1
	else:
		%OptionButton_MotionScript.selected = 0
	show_custom_script(use_custom_script)
	var custom_script_path = ProjectSettings.get_setting("parallax_wizard/parallax/movement_script/custom_script_path", null)
	if custom_script_path:
		%ScriptButton_CustomMotion.text = custom_script_path.name
	else:
		%ScriptButton_CustomMotion.text = "[none selected]"
	%SpinBox_DefaultSpeed.value = ProjectSettings.get_setting("parallax_wizard/parallax/movement_script/default_speed", 0)
	var randomize_speed = ProjectSettings.get_setting("parallax_wizard/parallax/movement_script/randomize_speed", false)
	%CheckBox_RandomSpeed.button_pressed = randomize_speed
	show_speed_range(randomize_speed)
	%SpinBox_SpeedRange.value = ProjectSettings.get_setting("parallax_wizard/parallax/movement_script/speed_offset_range", 0)
	%CheckBox_SpeedFluctuate.button_pressed = ProjectSettings.get_setting("parallax_wizard/parallax/movement_script/speed_fluctuates", false)
	var direction = ProjectSettings.get_setting("parallax_wizard/parallax/movement_script/default_direction", Vector2.ZERO)
	%SpinBox_Direction_X.value = direction.x
	%SpinBox_Direction_Y.value = direction.y
	var randomize_direction = ProjectSettings.get_setting("parallax_wizard/parallax/movement_script/randomize_direction", false)
	%CheckBox_RandomDirection.button_pressed = randomize_direction
	show_direction_range(randomize_direction)
	%SpinBox_DirectionRange.value = ProjectSettings.get_setting("parallax_wizard/parallax/movement_script/direction_offset_range", 0)
	%CheckBox_DirectionFluctuate.button_pressed = ProjectSettings.get_setting("parallax_wizard/parallax/movement_script/direction_fluctuates", false)
	%LineEdit_BackgroundName.text = ProjectSettings.get_setting("parallax_wizard/parallax/default_names/new_background_nodes", "ParallaxWizardBackground")
	%LineEdit_LayerName.text = ProjectSettings.get_setting("parallax_wizard/parallax/default_names/new_layer_nodes", "ParallaxLayer")


func show_z_indexes(active : bool = true):
	%Grid_ZValues.visible = active


func show_custom_script(active : bool = true):
	if active:
		%Margin_CustomMotion.visible = true
		%Margin_DefaultMotion.visible = false
	else:
		%Margin_CustomMotion.visible = false		
		%Margin_DefaultMotion.visible = true


func show_speed_range(active : bool = true):
	%Label_SpeedRange.visible = active
	%SpinBox_SpeedRange.visible = active
	%CheckBox_SpeedFluctuate.visible = active


func show_direction_range(active : bool = true):
	%Label_DirectionRange.visible = active
	%SpinBox_DirectionRange.visible = active
	%CheckBox_DirectionFluctuate.visible = active


func save_settings():
	var error : int = ProjectSettings.save()
	if error:
		push_error("Encountered error %d when saving project settings." % error)


func _on_check_box_automatic_convert_toggled(toggled_on):
	ProjectSettings.set_setting("parallax_wizard/parallax/automatic_convert", toggled_on)
	save_settings()

func _on_check_box_position_when_scaling_toggled(toggled_on):
	ProjectSettings.set_setting("parallax_wizard/parallax/preserve_positions_when_scaling", toggled_on)
	save_settings()

func _on_spin_box_fg_motion_max_value_changed(value):
	ProjectSettings.set_setting("parallax_wizard/parallax/motion_scale/foreground_motion_scale_max", value)
	save_settings()

func _on_spin_box_bg_motion_min_value_changed(value):
	ProjectSettings.set_setting("parallax_wizard/parallax/motion_scale/background_motion_scale_min", value)
	save_settings()

func _on_spin_box_cloud_motion_scale_value_changed(value):
	ProjectSettings.set_setting("parallax_wizard/parallax/motion_scale/cloud_motion_scale", value)
	save_settings()
	
func _on_spin_box_star_motion_scale_value_changed(value):
	ProjectSettings.set_setting("parallax_wizard/parallax/motion_scale/star_motion_scale", value)
	save_settings()

func _on_spin_box_motion_scale_x_value_changed(value):
	ProjectSettings.set_setting("parallax_wizard/parallax/motion_scale/motion_scale_factor", Vector2(value, ProjectSettings.get_setting("parallax_wizard/parallax/motion_scale/motion_scale_factor").y))
	save_settings()

func _on_spin_box_motion_scale_y_value_changed(value):
	ProjectSettings.set_setting("parallax_wizard/parallax/motion_scale/motion_scale_factor", Vector2(ProjectSettings.get_setting("parallax_wizard/parallax/motion_scale/motion_scale_factor").x, value))
	save_settings()

func _on_check_box_automatic_z_values_toggled(toggled_on):
	ProjectSettings.set_setting("parallax_wizard/parallax/z_indexes/automatic_z_indexes", toggled_on)
	save_settings()
	show_z_indexes(toggled_on)

func _on_spin_box_fgz_min_value_changed(value):
	ProjectSettings.set_setting("parallax_wizard/parallax/z_indexes/foreground_z_index_min", value)
	save_settings()

func _on_spin_box_fgz_max_value_changed(value):
	ProjectSettings.set_setting("parallax_wizard/parallax/z_indexes/foreground_z_index_max", value)
	save_settings()

func _on_spin_box_bgz_min_value_changed(value):
	ProjectSettings.set_setting("parallax_wizard/parallax/z_indexes/background_z_index_min", value)
	save_settings()

func _on_spin_box_bgz_max_value_changed(value):
	ProjectSettings.set_setting("parallax_wizard/parallax/z_indexes/background_z_index_max", value)
	save_settings()

func _on_spin_box_cloud_z_value_changed(value):
	ProjectSettings.set_setting("parallax_wizard/parallax/z_indexes/cloud_z_index", value)
	save_settings()

func _on_spin_box_star_z_value_changed(value):
	ProjectSettings.set_setting("parallax_wizard/parallax/z_indexes/star_z_index", value)
	save_settings()

func _on_option_button_motion_script_item_selected(index):
	var using_custom : bool = false
	if index == 1:
		using_custom = true
	ProjectSettings.set_setting("parallax_wizard/parallax/movement_script/use_custom_script", using_custom)
	save_settings()
	show_custom_script(using_custom)

func _on_script_button_custom_motion_pressed():
	#PULL UP SELECTION POP UP WINDOW
	save_settings()

func _on_spin_box_default_speed_value_changed(value):
	ProjectSettings.set_setting("parallax_wizard/parallax/movement_script/default_speed", value)
	save_settings()

func _on_check_box_random_speed_toggled(toggled_on):
	ProjectSettings.set_setting("parallax_wizard/parallax/movement_script/randomize_speed", toggled_on)
	save_settings()
	show_speed_range(toggled_on)

func _on_spin_box_speed_range_value_changed(value):
	ProjectSettings.set_setting("parallax_wizard/parallax/movement_script/speed_offset_range", value)
	save_settings()

func _on_check_box_speed_fluctuate_toggled(toggled_on):
	ProjectSettings.set_setting("parallax_wizard/parallax/movement_script/speed_fluctuates", toggled_on)
	save_settings()

func _on_spin_box_direction_x_value_changed(value):
	ProjectSettings.set_setting("parallax_wizard/parallax/movement_script/default_direction", Vector2(value, ProjectSettings.get_setting("parallax_wizard/parallax/movement_script/default_direction").y))
	save_settings()

func _on_spin_box_direction_y_value_changed(value):
	ProjectSettings.set_setting("parallax_wizard/parallax/movement_script/default_direction", Vector2(ProjectSettings.get_setting("parallax_wizard/parallax/movement_script/default_direction").x, value))
	save_settings()

func _on_check_box_random_direction_toggled(toggled_on):
	ProjectSettings.set_setting("parallax_wizard/parallax/movement_script/randomize_direction", toggled_on)
	save_settings()
	show_direction_range(toggled_on)

func _on_spin_box_direction_range_value_changed(value):
	ProjectSettings.set_setting("parallax_wizard/parallax/movement_script/direction_offset_range", value)
	save_settings()

func _on_check_box_direction_fluctuate_toggled(toggled_on):
	ProjectSettings.set_setting("parallax_wizard/parallax/movement_script/direction_fluctuates", toggled_on)
	save_settings()

func _on_line_edit_background_name_text_submitted(new_text):
	ProjectSettings.set_setting("parallax_wizard/parallax/default_names/new_background_nodes", new_text)
	save_settings()

func _on_line_edit_layer_name_text_submitted(new_text):
	ProjectSettings.set_setting("parallax_wizard/parallax/default_names/new_layer_nodes", new_text)
	save_settings()

func _on_button_restore_default_pressed():
	restore_defaults.emit()

func _on_button_exit_pressed():
	queue_free()
