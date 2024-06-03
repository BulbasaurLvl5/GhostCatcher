@tool
class_name ParallaxWizardControl
extends Control


var pw
var scroll_locked : bool = false:
	set(value):
		if scroll_locked == value:
			return
		scroll_locked = value
		pw.scroll_locked = value
		scroll_lock_sliders = Vector2.ZERO
		%VSlider_Scroll.editable = value
		%HSlider_Scroll.editable = value
		%TextureRect_Crosshairs.self_modulate.a = int(value)
		%VSlider_Scroll.value = float(value) - 1.0
		%HSlider_Scroll.value = float(value) - 1.0
		var color : Color
		if value:
			color = Color.CRIMSON
		else:
			color = Color.DIM_GRAY
		%VSlider_Scroll.self_modulate = color
		%HSlider_Scroll.self_modulate = color
var scroll_lock_sliders : Vector2 = Vector2.ZERO:
	set(value):
		if scroll_lock_sliders == value || !scroll_locked:
			return
		scroll_lock_sliders = value
		if scroll_lock_shifting:
			pw.update_scroll_lock_target(scroll_lock_sliders * Vector2(1.0, -1.0))
		else:
			%VSlider_Scroll.value = scroll_lock_sliders.y
			%HSlider_Scroll.value = scroll_lock_sliders.x
var scroll_lock_shifting : bool = false:
	set(value):
		if scroll_lock_shifting == value:
			return
		scroll_lock_shifting = value
var layer_count : int:
	set(value):
		layer_count = value
		%LayerCount.text = str(value)
		if value == 1:
			%Label_LayerCount.text = "ParallaxPlus Layer"
		else:
			%Label_LayerCount.text = "ParallaxPlus Layers"
		distance_available()


func set_up(pw_instance : Node):
	pw = pw_instance


func distance_available():
	if layer_count > 0:
		%Slider_Distance.editable = true
		%OptionButton_ModeDistance.disabled = false
		if %SpinBox_ModeDistance.visible:
			%SpinBox_ModeDistance.editable = true
	else:
		%Slider_Distance.editable = false
		%OptionButton_ModeDistance.disabled = true
		%SpinBox_ModeDistance.editable = false


#SIGNAL METHODS
func _on_distance_hover_entered():
	if pw.selected_layers:
		pw.selection_mode = pw.SelectionModes.DISTANCE
		

func _on_hover_exited():
	pw.selection_mode = pw.SelectionModes.DEFAULT


#DISTANCE TOOL SIGNAL METHODS
func _on_slider_distance_drag_started():
	pw.start_distance_shift(%OptionButton_ModeDistance.selected, %SpinBox_ModeDistance.value)

func _on_slider_distance_value_changed(value):
	pw.shift_distance(value)

func _on_slider_distance_drag_ended(value_changed):
	pw.shifting_distance = false
	%Slider_Distance.value = 0.0

func _on_option_button_mode_distance_item_selected(index):
	if index == pw.DistanceModes.OTHER:
		%OptionButton_ModeDistance.set_item_text(3, "Relative to")
		%SpinBox_ModeDistance.visible = true
		%Button_ModeDistanceCurrentBG.visible = true
		%Label_MinDistance.text = "Together"
		%Label_MaxDistance.text = "Apart"
	else:
		%OptionButton_ModeDistance.set_item_text(3, "Relative to Custom Value")
		%SpinBox_ModeDistance.visible = false
		if index == pw.DistanceModes.DEFAULT:
			%Label_MinDistance.text = "Together"
			%Label_MaxDistance.text = "Apart"
		else:
			%Label_MinDistance.text = "Min"
			%Label_MaxDistance.text = "Max"

func _on_button_mode_distance_current_bg_pressed():
	var value = clamp(pw.selected_layers[0].distance, -1.0, 1.0)
	%SpinBox_ModeDistance.value = value


#MAIN TOOL SIGNAL METHODS

func _on_button_settings_pressed():
	pw.open_settings()

func _on_button_convert_pressed():
	pw.convert_scene()
	pw.refresh_scene()

func _on_check_box_scroll_lock_toggled(value):
	scroll_locked = value

func _on_scroll_lock_drag_started():
	scroll_lock_shifting = true

func _on_scroll_lock_drag_ended(_value_changed):
	scroll_lock_shifting = false

func _on_v_slider_scroll_value_changed(value):
	if scroll_lock_shifting:
		scroll_lock_sliders = Vector2(scroll_lock_sliders.x, value)
		
func _on_h_slider_scroll_value_changed(value):
	if scroll_lock_shifting:
		scroll_lock_sliders = Vector2(value, scroll_lock_sliders.y)

func _on_menu_button_add_layer_about_to_popup():
	if !%MenuButton_AddLayer.get_popup().index_pressed.is_connected(_on_menu_button_add_layer_selected):
		%MenuButton_AddLayer.get_popup().index_pressed.connect(_on_menu_button_add_layer_selected)

func _on_menu_button_add_layer_selected(index : int):
	pw.add_new_layer(index)




func _on_h_slider_scroll_drag_ended(value_changed):
	pass # Replace with function body.
