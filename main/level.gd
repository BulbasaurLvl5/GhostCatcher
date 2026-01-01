@tool
class_name Level
extends Node2D

const TILE_SIZE : float = 110.0

@export var level_name : String:
	set(value):
		if level_name == value:
			return
		level_name = value
		name = value
@export var show_data_in_editor : bool = false:
	set(value):
		if show_data_in_editor == value:
			return
		show_data_in_editor = value
		queue_redraw()
@export var air_actions_enabled : bool = true
@export var radar_enabled : bool = true

#@export_category("Player Starting Position")
#@export_range(-50.0, 50.0, 0.5, "or_less", "or_greater", "suffix:tiles") var starting_position_x : float = 0.0:
	#set(value):
		#starting_position_x = value
		#calculate_starting_pos()
#@export_range(-50.0, 50.0, 0.5, "or_less", "or_greater", "suffix:tiles") var starting_position_y : float = 0.0:
	#set(value):
		#starting_position_y = value
		#calculate_starting_pos()
#@export var flip_player_direction : bool = false

@export_category("Lighting")
@export_range(0.0, 1.0, 0.01) var light_level : float = 0.75:
	set(value):
		if light_level == value:
			return
		light_level = clampf(value, 0.0, 1.0)
		adjust_lighting()
@export var show_lighting_in_editor : bool = false:
	set(value):
		if show_lighting_in_editor == value:
			return
		show_lighting_in_editor = value
		adjust_lighting()

@export_category("Level Boundary")
@export_range(-100.0, 0.0, 0.5, "or_less", "or_greater", "suffix:tiles") var top_boundary : float = -50.0:
	set(value):
		top_boundary = value
		calculate_boundary()
@export_range(-50.0, 0.0, 0.5, "or_less", "or_greater", "suffix:tiles") var left_boundary : float = -20.0:
	set(value):
		left_boundary = value
		calculate_boundary()
@export_range(0.0, 150.0, 0.5, "or_less", "or_greater", "suffix:tiles") var right_boundary : float = 20.0:
	set(value):
		right_boundary = value
		calculate_boundary()
@export_range(0.0, 50.0, 0.5, "or_less", "or_greater", "suffix:tiles") var bottom_boundary : float = 20.0:
	set(value):
		bottom_boundary = value
		calculate_boundary()


var level_boundary : Rect2:
	set(value):
		level_boundary = value
		queue_redraw()
var starting_pos : Vector2:
	set(value):
		starting_pos = value
		queue_redraw()

var player : Player:
	set(value):
		if player == value:
			return
		else:
			player = value
			#player.position = starting_pos
			player.level_boundary = level_boundary
			player.air_actions_enabled = air_actions_enabled
			if !air_actions_enabled:
				player.remaining_air_actions = 0
			player.radar_enabled = radar_enabled
var camera : Camera:
	set(value):
		if camera == value:
			return
		else:
			camera = value
			camera.level_boundary = level_boundary
#var canvas_mod : CanvasModulate

var main: Main
var ghosts: Array[Ghost]
var time_label: Label
var center_label: CenterLabel
var clock: Clock


func calculate_boundary():
	level_boundary = Rect2(left_boundary * TILE_SIZE, top_boundary * TILE_SIZE, (right_boundary - left_boundary) * TILE_SIZE, (bottom_boundary - top_boundary) * TILE_SIZE)
	show_data_in_editor = true


#func calculate_starting_pos():
	#starting_pos = Vector2(starting_position_x * TILE_SIZE, starting_position_y * TILE_SIZE)
	#show_data_in_editor = true


func _enter_tree():
	if !Engine.is_editor_hint():
		#search_scene()
		player = NodeExtention.get_child_by_script(self,Player,true)
		camera = NodeExtention.get_child_by_script(self,Camera,true)
		main = NodeExtention.get_child_by_script(NodeExtention.get_root(self),Main,true)
		clock = NodeExtention.get_child_by_script(self,Clock)
		
		clock.start()
		clock.register_timed_callback(-2, func(): 
			center_label.tween_text("WAKE UP!")
			)
		clock.register_timed_callback(-1, func(): 
			center_label.tween_text("WORK!")
			)
		clock.register_timed_callback(0, func(): 
			player.process_mode = Node.PROCESS_MODE_ALWAYS
			center_label.tween_text("")
			)
		
		if(main):
			time_label = NodeExtention.instantiate(SceneLibrary.TIME_LABEL,main.ui)
			center_label = NodeExtention.instantiate(SceneLibrary.CENTER_LABEL,main.ui)
			
		if get_parent() == get_tree().root: # debug mode, ie started from editor
			player.process_mode = Node.PROCESS_MODE_ALWAYS
	adjust_lighting()


func _ready():
	if !Engine.is_editor_hint():
		#if !player || !camera:
			#search_scene()
		ghosts.assign(NodeExtention.get_children_by_script(self, Ghost, true))
	else: # things happening in the engine
		level_name = name
		renamed.connect(_on_renamed)
		show_data_in_editor = false


func _process(_delta):
	if !Engine.is_editor_hint():
		#if !player || !camera:
			##print("level_parameters _process() calling search_scene()")
			#search_scene()

		clean_array(ghosts, func(obj): return obj == null)
		if ghosts.size() == 0:
			#center_label.tween_text("SUCCESS!")
			clock.stop()
			player.process_mode = Node.PROCESS_MODE_DISABLED
		
		if(time_label):
			time_label.text = Clock.float_to_string(clock.time)
			
	elif level_name != name:
		level_name = name


func _draw():
	if Engine.is_editor_hint() && show_data_in_editor:
		if level_boundary:
			draw_rect(level_boundary, Color(Color.GOLDENROD, 0.25))
		draw_rect(Rect2(starting_pos.x - (TILE_SIZE * 0.5), starting_pos.y - (TILE_SIZE * 0.5), TILE_SIZE, TILE_SIZE), Color(Color.CRIMSON, 0.5))
		draw_rect(Rect2(starting_pos.x - (TILE_SIZE * 1.5), starting_pos.y - (TILE_SIZE * 1.5), (TILE_SIZE * 3.0), (TILE_SIZE * 3.0)), Color(Color.FUCHSIA, 0.25))
	else:
		pass


func adjust_lighting():
	if !is_inside_tree():
		return
	#if !canvas_mod:
		#canvas_mod = CanvasModulate.new()
		#add_child(canvas_mod)
	var lights = get_tree().get_nodes_in_group("player_light")
	lights.append_array(get_tree().get_nodes_in_group("ghost_lights"))
	if Engine.is_editor_hint() && !show_lighting_in_editor:
		#canvas_mod.color = Color.WHITE
		for light in lights:
			light.energy = 0.0
	else:	
		#canvas_mod.color = Color(light_level, light_level, light_level)
		for light in lights:
			light.energy = 1.0 - light_level
	

#func search_scene():
	#var nodes = get_all_children(get_tree().root)
	#if !player:
		#for n in nodes:
			#if n is Player:
				#player = n
				#break
	#if !camera:
		#for n in nodes:
			#if n is Camera2D:
				#camera = n
				#break


#func get_all_children(node) -> Array:
	#if !node:
		#return []
	#var all_children : Array = []
	#var children = node.get_children()
	#for c in children:
		#if c.get_child_count() > 0:
			#all_children.append(c)
			#all_children.append_array(get_all_children(c))
		#else:
			#all_children.append(c)
	#return all_children


func _on_renamed():
	if name != level_name:
		level_name = name


func clean_array(array: Array, lambda_func: Callable) -> Array:
	for i in range(array.size() - 1, -1, -1):  # Iterate in reverse
		if lambda_func.call(array[i]): 
			array.remove_at(i)  # Remove the object from the array
	return array
