@tool
extends EditorPlugin

#SIGNALS
signal scroll_lock_toggled
signal scroll_lock_moved

#CONSTANTS
const control_preload = preload("res://addons/parallax_wizard/plugin/pw_control.tscn")
const settings_preload = preload("res://addons/parallax_wizard/plugin/pw_settings.tscn")
const custom_preload = preload("res://addons/parallax_wizard/plugin/pw_custom.tscn")
const crosshairs_preload = preload("res://addons/parallax_wizard/plugin/pw_crosshairs_1080.png")
const crosshairs_color : Color = Color(Color.CRIMSON, 128)
const crosshairs_z_index : int = 3000
#const crosshairs_scale : Vector2 = Vector2(0.5, 0.5)
const view_margin : Vector2 = Vector2(0.1, 0.1)

#NODE REFERENCES
var active_scene_root : Node:
	set(value):
		if active_scene_root == value:
			return
		active_scene_root = value
		if active_scene_root:
			if !active_scene_root.tree_exited.is_connected(_on_active_scene_change):
				active_scene_root.tree_exited.connect(_on_active_scene_change)
var control_scene
var settings_scene
var custom_scene
var crosshairs : Sprite2D
var view_center : Vector2

var editor_selection

#CUSTOM BUTTONS
var custom_cat_names : Array[String]:
	set(value):
		custom_cat_names = value
		save_custom_data()
var custom_item_paths : Array[Array]:
	set(value):
		custom_item_paths = value
		save_custom_data()
var custom_item_names : Array[Array]:
	set(value):
		custom_item_names = value
		save_custom_data()

#NODE ARRAYS
var scene_layers : Array[ParallaxPlus]
var selected_layers : Array[ParallaxPlus]
var unconverted_old_layers : Array[ParallaxLayer]
var unconverted_new_layers : Array[Parallax2D]
var selected_canvas_items : Array[CanvasItem]
var stored_node_selection : Array[Node]
var active_node_selection : Array[Node]
var stored_node_values : Array[float]
var stored_colors_rgb : Array[Color]
var stored_colors_hsl : Array[Dictionary]
var shifting_distance : bool = false
var shifting_color : bool = false
var shift_mode : int
var shift_relative_to : int
var shift_color_parameter : int

#SCROLL LOCK
var scroll_locked : bool = false:
	set(value):
		if scroll_locked == value || !control_scene:
			return
		scroll_locked = value
		scroll_lock_toggled.emit(value)	
		activate_crosshairs(value)
var scroll_lock_target : Vector2 = Vector2.ZERO:
	set(value):
		if scroll_lock_target == value:
			return
		scroll_lock_target = value
		scroll_lock_moved.emit(value)
		crosshairs.global_position = scroll_lock_target

enum ControlStatus {BOTTOM, DOCK, WINDOW}
var control_status = ControlStatus.BOTTOM
enum SelectionModes {DEFAULT, DISTANCE, COLOR, ADD_BG, ADD_LAYER, ADD_MOTION, RESOLVE}
var selection_mode = SelectionModes.DEFAULT:
	set(value):
		if selection_mode == value:
			return
		if value == SelectionModes.DEFAULT:
			if stored_node_selection:
				editor_selection.clear()
				for n in stored_node_selection:
					editor_selection.add_node(n)
					EditorInterface.edit_node(n)
		else:
			#count_selected_nodes()
			stored_node_selection = editor_selection.get_selected_nodes()
			editor_selection.clear()
			var nodes : Array = []
			if value == SelectionModes.DISTANCE:
				nodes.append_array(selected_layers)
			elif value == SelectionModes.COLOR:
				nodes = selected_canvas_items
			elif value == SelectionModes.ADD_BG:
				nodes.append(get_tree().get_edited_scene_root())
			elif value ==  SelectionModes.ADD_LAYER:
				pass
			elif value == SelectionModes.ADD_MOTION:
				nodes.append(selected_layers)
			for n in nodes:
				editor_selection.add_node(n)
				EditorInterface.edit_node(n)
		selection_mode = value
var single_node : Node = null:
	set(value):
		single_node = value
		if custom_scene:
			custom_scene.single_node = value

enum DistanceModes {CAMERA, DEFAULT, HORIZON, OTHER, LINEAR, OVERRIDE}
enum ColorEditTypes {MODULATE, SELF_MODULATE}
var color_edit_type = ColorEditTypes.MODULATE
enum ColorParameters {HUE, SATURATION, LIGHTNESS, ALPHA, RED, GREEN, BLUE}
enum ColorModes {ZERO, ONE, OTHER, LINEAR, OVERRIDE}
enum LayerTypes {DEFAULT, HAZE, CLOUDS, SKY}
var restoring_defaults : bool = false

var timer : Timer


func _enter_tree():
	initialize_settings(false)
	load_custom_data()
	create_control()
	editor_selection = EditorInterface.get_selection()
	count_selected_nodes()
	editor_selection.selection_changed.connect(count_selected_nodes)


func _ready():
	timer = Timer.new()
	self.add_child(timer)
	timer.wait_time = 1.0
	timer.timeout.connect(do_checks)
	timer.start()
	do_checks()


func _process(delta):
	if scroll_locked && crosshairs:
		var dimensions = get_view_dimensions()
		if dimensions["center"] != view_center:
			view_center = dimensions["center"]
			update_crosshairs(true, dimensions)


func _exit_tree():
	if control_status == ControlStatus.BOTTOM:
		remove_control_from_bottom_panel(control_scene)
	elif control_status == ControlStatus.DOCK:
		remove_control_from_docks(control_scene)

	if crosshairs:
		crosshairs.queue_free()
	if control_scene:
		control_scene.queue_free()
	if settings_scene:
		settings_scene.queue_free()
	if custom_scene:
		custom_scene.queue_free()


func do_checks():
	if !active_scene_root:
		active_scene_root = EditorInterface.get_edited_scene_root()
	check_layers()


func check_layers():
	if !active_scene_root:
		return
	var nodes = get_all_children(active_scene_root)
	for n in nodes:
		if n is ParallaxPlus:
			if !scene_layers.has(n):
				scene_layers.append(n)
				if !scroll_lock_toggled.is_connected(n._on_plugin_scroll_lock_toggled):
					scroll_lock_toggled.connect(n._on_plugin_scroll_lock_toggled)
				if !scroll_lock_moved.is_connected(n._on_plugin_scroll_lock_moved):
					scroll_lock_moved.connect(n._on_plugin_scroll_lock_moved)
				n.scroll_locked = scroll_locked
				if scroll_locked:
					n.screen_offset = scroll_lock_target


func activate_crosshairs(activate : bool = true):
	if activate:
		crosshairs = Sprite2D.new()
		crosshairs.texture = crosshairs_preload
		crosshairs.self_modulate = crosshairs_color
		crosshairs.z_index = crosshairs_z_index
		
		active_scene_root.add_child(crosshairs)
		var dimensions = get_view_dimensions()
		crosshairs.global_position = dimensions["center"]
		update_crosshairs(true)
	else:
		crosshairs.queue_free()


func update_crosshairs(and_sliders : bool, dimensions : Dictionary = get_view_dimensions()):
	if !crosshairs || !control_scene:
		return
	#crosshairs.scale = dimensions["inverse"].get_scale() * crosshairs_scale
	if and_sliders:
		var slider_pos : Vector2 =  (crosshairs.global_position - dimensions["center"]) / (dimensions["size"] / 2.0)
		slider_pos.x = clamp(slider_pos.x, -1.0, 1.0)
		slider_pos.y = -1.0 * clamp(slider_pos.y, -1.0, 1.0)
		control_scene.scroll_lock_sliders = slider_pos
		

func update_scroll_lock_target(slider_input : Vector2):
	var target : Vector2
	var dimensions = get_view_dimensions()
	var offset = slider_input * dimensions["size"] / 2.0
	target = dimensions["center"] + offset
	if scroll_locked:
		scroll_lock_target = target


func get_view_dimensions() -> Dictionary:
	var dimensions : Dictionary
	var view = EditorInterface.get_editor_viewport_2d()
	var inverse = view.get_global_canvas_transform().affine_inverse()
	var view_size = Vector2(float(view.size.x) * inverse.get_scale().x, float(view.size.y) * inverse.get_scale().y)
	var view_center = inverse.origin + view_size / 2
	dimensions = {"inverse": inverse, "size": view_size, "center": view_center}
	return dimensions


func create_control():
	control_scene = control_preload.instantiate()
	add_control_to_bottom_panel(control_scene, "Parallax Wizard")
	control_status = ControlStatus.BOTTOM
	control_scene.set_up(self)


func add_new_layer(type : int = LayerTypes.DEFAULT, parent : Node = null):
	#editor_selection.clear()
	#stored_node_selection.clear()
	if parent == null:
		if single_node:
			parent = single_node
		else:
			parent = active_scene_root
	if parent is ParallaxPlus:
		parent = active_scene_root
	var layer = ParallaxPlus.new()
	parent.add_child(layer)
	layer.owner = active_scene_root
	layer.name = "Parallax"
	layer.type = type
	stored_node_selection.append(layer)
	
	if type == LayerTypes.SKY:
		layer.name = "Parallax_Sky"
		var sky = ColorRect.new()
		layer.add_child(sky)
		#layer.set_motion_mirroring(get_viewport().size)
		sky.set_size(get_viewport().size)
		sky.set_color(Color.DEEP_SKY_BLUE)
		sky.name = "ColorRect_Sky"
		sky.owner = active_scene_root
		stored_node_selection.append(sky)
	elif type == LayerTypes.CLOUDS:
		layer.name = "Parallax_Clouds"
		var clouds = ColorRect.new()
		layer.add_child(clouds)
		#layer.set_motion_mirroring(get_viewport().size)
		clouds.set_size(get_viewport().size)
		clouds.set_color(Color.WHITE_SMOKE)
		clouds.self_modulate.a = 0.25
		clouds.name = "ColorRect_Clouds"
		clouds.owner = active_scene_root
		stored_node_selection.append(clouds)
	elif type == LayerTypes.HAZE:
		layer.distance = 0.5
		layer.name = "Parallax_Haze"
		var haze = ColorRect.new()
		layer.add_child(haze)
		#layer.set_motion_mirroring(get_viewport().size)
		haze.set_size(get_viewport().size)
		haze.set_color(Color.DIM_GRAY)
		haze.self_modulate.a = 0.25
		haze.name = "ColorRect_Haze"
		haze.owner = active_scene_root
		stored_node_selection.append(haze)
	else:
		layer.distance = 0.0
	

#func get_scene_input() -> Array:
	#var scenes : Array[PackedScene]
	#var dialog = EditorFileDialog.new()
	#dialog.mode = EditorFileDialog.FILE_MODE_OPEN_FILES
	#dialog.access = EditorFileDialog.ACCESS_RESOURCES 
	##dialog.popup()
	#var view = EditorInterface.get_editor_viewport_2d()
	#view.add_child(dialog)
	#return scenes
	

func count_selected_nodes():
	var nodes = editor_selection.get_selected_nodes()
	
	if nodes.size() == 1:
		single_node = nodes[0]
	else:
		single_node = null
	
	if selection_mode != SelectionModes.DEFAULT:
		return
	
	selected_layers.clear()
	selected_canvas_items.clear()
	var c_items : Array[CanvasItem]

	for n in nodes:
		if n is ParallaxPlus:
			selected_layers.append(n)
		if n is CanvasItem:
			c_items.append(n)
	"layout_mode"
	if c_items && color_edit_type == ColorEditTypes.MODULATE:
		selected_canvas_items = cull_canvas_items(c_items)
	else:
		selected_canvas_items = c_items
	
	if !control_scene:
		create_control()
	control_scene.layer_count = selected_layers.size()
	control_scene.canvas_item_count = selected_canvas_items.size()
	
	if selected_layers:
		open_control()


func cull_canvas_items(items : Array) -> Array:
	var remaining = items
	for i in items:
		var children = i.get_children(true)
		for c in children:
			if c is CanvasItem:
				if remaining.has(c):
					remaining.erase(c)
	return remaining


func open_control():
	if control_status == ControlStatus.BOTTOM:
		make_bottom_panel_item_visible(control_scene)
	else:
		control_scene.visible = true


func start_distance_shift(mode : int, relative_to : float):
	stored_node_values.clear()
	for b in selected_layers:
		stored_node_values.append(b.distance)

	shift_mode = mode
	if shift_mode == DistanceModes.CAMERA:
		shift_relative_to = -1.0
	elif shift_mode == DistanceModes.DEFAULT:
		shift_relative_to = 0.0
	elif shift_mode == DistanceModes.HORIZON:
		shift_relative_to = 1.0
	else:
		shift_relative_to = relative_to
	shifting_distance = true

	
func start_color_shift(parameter : int, mode : int, relative_to : float):
	stored_colors_rgb.clear()
	if color_edit_type == ColorEditTypes.MODULATE:
		for b in selected_canvas_items:
			stored_colors_rgb.append(b.modulate)
	else:
		for b in selected_canvas_items:
			stored_colors_rgb.append(b.self_modulate)

	stored_colors_hsl.clear()
	for c in stored_colors_rgb:
		stored_colors_hsl.append(rgb_to_hsl(c))

	shift_color_parameter = parameter
	stored_node_values.clear()
	if shift_color_parameter == ColorParameters.HUE:
		for c in stored_colors_hsl:
			stored_node_values.append(c.h)
	elif shift_color_parameter == ColorParameters.SATURATION:
		for c in stored_colors_hsl:
			stored_node_values.append(c.s)
	elif shift_color_parameter == ColorParameters.LIGHTNESS:
		for c in stored_colors_hsl:
			stored_node_values.append(c.l)
	elif shift_color_parameter == ColorParameters.ALPHA:
		for c in stored_colors_rgb:
			stored_node_values.append(c.a)
	elif shift_color_parameter == ColorParameters.RED:
		for c in stored_colors_rgb:
			stored_node_values.append(c.r)
	elif shift_color_parameter == ColorParameters.GREEN:
		for c in stored_colors_rgb:
			stored_node_values.append(c.g)
	elif shift_color_parameter == ColorParameters.BLUE:
		for c in stored_colors_rgb:
			stored_node_values.append(c.b)

	shift_mode = mode
	if shift_mode == ColorModes.ZERO:
		shift_relative_to = 0.0
	elif shift_mode == ColorModes.ONE:
		shift_relative_to = 1.0
	else:
		shift_relative_to = relative_to
	
	shifting_color = true
			
			
func shift_distance(input : float):	
	if !shifting_distance:
		return
	
	var count = 0
	for l in selected_layers:
		var new : float
		if shift_mode == DistanceModes.OVERRIDE:
			new = input
		elif shift_mode == DistanceModes.LINEAR:
			new = stored_node_values[count] + input
		else:
			new = -1.0 + (2.0 * calculate_shift((stored_node_values[count] + 1.0) / 2.0, (input + 1.0) / 2.0, shift_relative_to))
		l.distance = clampf(new, -1.0, 1.0)
		count += 1
		
		
func shift_color(input : float):
	if !shifting_color:
		return

	var count = 0
	for i in selected_canvas_items:
		var value : float
		if shift_mode == ColorModes.OVERRIDE:
			value = input
		elif shift_mode == ColorModes.LINEAR:
			value = stored_node_values[count] + input - 0.5
		else:
			if shift_color_parameter == ColorParameters.HUE:
				if abs(stored_node_values[0] - shift_relative_to) > 0.5:
					shift_relative_to += 1.0 * sign(stored_node_values[count] - shift_relative_to)
				value = calculate_shift(stored_node_values[count], input, shift_relative_to, true)
			else:
				value = calculate_shift(stored_node_values[count], input, shift_relative_to, false)

		if shift_color_parameter == ColorParameters.HUE:
			bring_float_in_range(value, true)
		else:
			bring_float_in_range(value, false)
		
		var rgb : Color = stored_colors_rgb[count]
		var hsl : Dictionary = stored_colors_hsl[count]
		var color : Color = rgb
		if shift_color_parameter == ColorParameters.HUE:
			color = hsl_to_rgb(value, hsl.s, hsl.l)
			color.a = rgb.a
		elif shift_color_parameter == ColorParameters.SATURATION:
			color = hsl_to_rgb(hsl.h, value, hsl.l)
			color.a = rgb.a
		elif shift_color_parameter == ColorParameters.LIGHTNESS:
			color = hsl_to_rgb(hsl.h, hsl.s, value)
			color.a = rgb.a
		elif shift_color_parameter == ColorParameters.ALPHA:
			color.a = value		
		elif shift_color_parameter == ColorParameters.RED:
			color.r = value
		elif shift_color_parameter == ColorParameters.GREEN:
			color.g = value
		elif shift_color_parameter == ColorParameters.BLUE:
			color.b = value	
			
		if color_edit_type == ColorEditTypes.MODULATE:
			i.modulate = color
		else:
			i.self_modulate = color	
		count += 1


func calculate_shift(starting_value : float, input_value : float, relative_to : float, wraparound : bool = false) -> float:
	var new_value : float
	if relative_to == 1.0:
		new_value = lerpf(1.0 - (1.0 - starting_value) * 2.0, 1.0, input_value)
	else:
		new_value = lerpf(relative_to, starting_value * 2.0 - relative_to, input_value)
	new_value = bring_float_in_range(new_value, wraparound)
	return new_value


func bring_float_in_range(input_value : float, wraparound : bool = false, min : float = 0.0, max : float = 1.0) -> float:
	var new : float
	if wraparound:
		new = input_value
		while new > max:
			new -= max - min
		while input_value < min:
			new += max - min
	else:
		new = clamp(input_value, min, max)
	return new


func convert_and_refresh_project():
	print("CONVERT & REFRESH PROJECT feature not yet available. Limited to current scene only.")


func convert_scene():
	if active_scene_root:
		var nodes = get_all_children(active_scene_root)
		for n in nodes:
			if n is ParallaxBackground:
				convert_background(n)
			elif n is Parallax2D && !n is ParallaxPlus:
				convert_layer(n)


func get_all_children(node) -> Array:
	if !node:
		return []
	var all_children : Array = []
	var children = node.get_children()
	for c in children:
		if c.get_child_count() > 0:
			all_children.append(c)
			all_children.append_array(get_all_children(c))
		else:
			all_children.append(c)
	return all_children


func refresh_scene():
	if active_scene_root:
		var nodes = get_all_children(active_scene_root)
		for n in nodes:
			if n is ParallaxPlus:
				n._update_parallax_layer()


func convert_background(background : ParallaxBackground):
	var children = background.get_children()
	var parent = background.get_parent()
	for c in children:
		if c is ParallaxLayer:
			convert_layer(c, background)
	var replacement = Node.new()
	background.replace_by(replacement, true)
	replacement.name = background.name
	replacement.owner = active_scene_root
	background.queue_free()
	
	children = get_all_children(replacement)
	for c in children:
		c.owner = active_scene_root
	
func convert_layer(layer : Node, background : ParallaxBackground = null):
	if !layer is Parallax2D && !layer is ParallaxLayer:
		return
	var replacement = ParallaxPlus.new()
	layer.replace_by(replacement, true)
	replacement.name = layer.name
	replacement.owner = active_scene_root
	
	var children = get_all_children(replacement)
	for c in children:
		c.owner = active_scene_root
	
	var ms : Vector2
	if layer is ParallaxLayer:
		ms = layer.motion_scale
		if layer.motion_mirroring:
			replacement.repeat_times = 2
			replacement.repeat_size = layer.motion_mirroring
		if background:
			replacement.limit_begin = background.scroll_limit_begin
			replacement.limit_end = background.scroll_limit_end
	elif layer is Parallax2D:
		ms = layer.scroll_scale
		replacement.repeat_times = layer.repeat_times
		replacement.repeat_size = layer.repeat_size
		replacement.autoscroll = layer.autoscroll
		replacement.autoscroll_offset = layer.autoscroll_offset
		replacement.limit_begin = layer.limit_begin
		replacement.limit_end = layer.limit_end
		replacement.follow_viewport = layer.follow_viewport
		replacement.ignore_camera_scroll = layer.ignore_camera_scroll
			
	var ratio = ProjectSettings.get_setting("parallax_wizard/parallax/scroll_scale/xy_ratio")
	if ms.x > 1.0:
		replacement.distance = -1.0 * lerpf(0.0, 1.0, (ms.x - 1.0) / (ProjectSettings.get_setting("parallax_wizard/parallax/scroll_scale/foreground_max") - 1.0))
	elif ms.x <= ProjectSettings.get_setting("parallax_wizard/parallax/scroll_scale/sky"):
		replacement.type = LayerTypes.SKY
	elif ms.x <= ProjectSettings.get_setting("parallax_wizard/parallax/scroll_scale/clouds"):
		replacement.type = LayerTypes.CLOUDS
	elif ms.x < 1.0:
		replacement.distance = lerpf(0.0, 1.0, (1.0 - ms.x) / (1.0 - ProjectSettings.get_setting("parallax_wizard/parallax/scroll_scale/background_min")))

	if scroll_locked:
		replacement.scroll_locked = true
		replacement._on_plugin_scroll_lock_moved(scroll_lock_target)
	scroll_lock_toggled.connect(replacement._on_plugin_scroll_lock_toggled)
	scroll_lock_moved.connect(replacement._on_plugin_scroll_lock_moved)
	layer.queue_free()


func add_custom_item(item : PackedScene):
	var nodes = editor_selection.get_selected_nodes()
	for n in nodes:
		var new = item.new()
		n.add_child(new)


func open_settings():
	settings_scene = settings_preload.instantiate()
	get_tree().root.add_child(settings_scene)
	settings_scene.restore_defaults.connect(_on_settings_restore_defaults)


func open_custom_edit_menu():
	custom_scene = custom_preload.instantiate()
	get_tree().root.add_child(custom_scene)
	custom_scene.set_up(self)


func rgb_to_hsl(rgb : Color) -> Dictionary:
	var hsl : Dictionary = {"h" = 0.0, "s" = 0.0, "l" = 0.0}
	var maxc : float = max(rgb.r, rgb.g, rgb.b)
	var minc : float = min(rgb.r, rgb.g, rgb.b)
	var sumc : float = (maxc + minc)
	var rangec : float = (maxc - minc)
	hsl.l = sumc / 2.0
	if minc == maxc:
		return hsl
	if hsl.l <= 0.5:
		hsl.s = rangec / sumc
	else:
		hsl.s = rangec / (2.0 - maxc - minc)
	var rc : float = (maxc - rgb.r) / rangec
	var gc : float = (maxc - rgb.g) / rangec
	var bc : float = (maxc - rgb.b) / rangec
	if rgb.r == maxc:
		hsl.h = bc - gc
	elif rgb.g == maxc:
		hsl.h = 2.0 + rc - bc
	else:
		hsl.h = 4.0 + gc - rc
	hsl.h = (hsl.h / 6.0) - int(hsl.h / 6.0)
	return hsl


func hsl_to_rgb(h : float, s : float, l : float) -> Color:
	var rgb : Color = Color(l, l, l)
	if s == 0.0:
		return rgb
	var m2 : float
	if l <= 0.5:
		m2 = l * (1.0 + s)
	else:
		m2 = l + s - (l * s)
	var m1 : float = 2.0 * l - m2
	rgb.r = get_color_value(m1, m2, h + (1.0 / 3.0))
	rgb.g = get_color_value(m1, m2, h)
	rgb.b = get_color_value(m1, m2, h - (1.0 / 3.0))
	return rgb


func get_color_value(m1 : float, m2 : float, hue : float) -> float:
	var v : float
	hue = hue - int(hue)
	if hue < (1.0 / 6.0):
		v = m1 + (m2 - m1) * hue * 6.0
	elif hue < 0.5:
		v = m2
	elif hue < (2.0 / 3.0):
		v = m1 + (m2 - m1) * ((2.0 / 3.0) - hue) * 6.0
	else:
		v = m1
	return v


func _on_settings_restore_defaults():
	initialize_settings(true)
	
func _on_active_scene_change():
	active_scene_root = null
	scene_layers.clear()
	#var connections = scroll_lock_toggled.get_connections()
	#for c in connections:
		#scroll_lock_toggled.disconnect(c)
	#var connections = scroll_lock_moved.get_connections()
	#for c in connections:
		#scroll_lock_moved.disconnect(c)


func initialize_settings(overwrite_existing_settings : bool = false):
	restoring_defaults = overwrite_existing_settings
	initialize_custom_project_setting("parallax_wizard/parallax/automatically_convert_parallax_nodes", true, TYPE_BOOL)
	initialize_custom_project_setting("parallax_wizard/parallax/scroll_scale/foreground_max", 1.25, TYPE_FLOAT)
	initialize_custom_project_setting("parallax_wizard/parallax/scroll_scale/background_min", 0.1, TYPE_FLOAT)
	initialize_custom_project_setting("parallax_wizard/parallax/scroll_scale/clouds", 0.05, TYPE_FLOAT)
	initialize_custom_project_setting("parallax_wizard/parallax/scroll_scale/sky", 0.01, TYPE_FLOAT)
	initialize_custom_project_setting("parallax_wizard/parallax/scroll_scale/xy_ratio", Vector2(1.0, 0.5), TYPE_VECTOR2)
	initialize_custom_project_setting("parallax_wizard/parallax/z_indexes/set_automatically", true, TYPE_BOOL)
	initialize_custom_project_setting("parallax_wizard/parallax/z_indexes/foreground_max", 1000, TYPE_INT)
	initialize_custom_project_setting("parallax_wizard/parallax/z_indexes/foreground_min", 11, TYPE_INT)
	initialize_custom_project_setting("parallax_wizard/parallax/z_indexes/background_max", -11, TYPE_INT)
	initialize_custom_project_setting("parallax_wizard/parallax/z_indexes/background_min", -1000, TYPE_INT)	
	initialize_custom_project_setting("parallax_wizard/parallax/z_indexes/clouds", -1001, TYPE_INT)
	initialize_custom_project_setting("parallax_wizard/parallax/z_indexes/sky", -2000, TYPE_INT)
	var error : int = ProjectSettings.save()
	if error:
		push_error("Encountered error %d when saving project settings." % error)

func initialize_custom_project_setting(name: String, default_value, type: float, hint: int = PROPERTY_HINT_NONE, hint_string: String = ""):
	if ProjectSettings.has_setting(name):
		return
	var setting_info: Dictionary = {
		"name": name,
		"type": type,
		"hint": hint,
		"hint_string": hint_string}
	ProjectSettings.set(name, default_value)
	ProjectSettings.add_property_info(setting_info)
	ProjectSettings.set_initial_value(name, default_value)


func load_custom_data():
	pass

func save_custom_data():
	pass
