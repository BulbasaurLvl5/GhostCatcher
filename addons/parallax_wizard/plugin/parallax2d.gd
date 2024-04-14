@tool
class_name Parallax2D
extends Node2D


@onready var in_editor : bool = Engine.is_editor_hint()

const DEFAULT_LIMIT : int = 10000000
var group_name : String
@export var scroll_scale : Vector2 = Vector2.ONE
@export var scroll_offset : Vector2:
	set(p_offset):
		if p_offset == scroll_offset:
			return
		scroll_offset = p_offset
		_update_scroll()

@export_group("Repeat")
@export var repeat_size : Vector2:
	set(p_repeat_size):
		if p_repeat_size == repeat_size:
			return
		repeat_size = Vector2(max(p_repeat_size.x, 0.0), max(p_repeat_size.y, 0.0))
		_update_process()
		_update_repeat()
		_update_scroll()
@export var autoscroll : Vector2:
	set(p_autoscroll):
		if p_autoscroll == autoscroll:
			return
		autoscroll = p_autoscroll
		autoscroll_offset = Vector2.ZERO
		_update_process()
		_update_scroll()
var autoscroll_offset : Vector2
@export var repeat_times : int = 1:
	set(p_repeat_times):
		if p_repeat_times == repeat_times:
			return
		repeat_times = max(p_repeat_times, 1)
		_update_repeat()
		
@export_group("Limit")
@export var limit_begin : Vector2 = Vector2(-DEFAULT_LIMIT, -DEFAULT_LIMIT)
@export var limit_end : Vector2 = Vector2(DEFAULT_LIMIT, DEFAULT_LIMIT)

@export_group("Override")
@export var follow_viewport : bool = true
@export var ignore_camera_scroll : bool = false
@export var screen_offset : Vector2:
	set(p_offset):
		if p_offset == screen_offset:
			return
		screen_offset = p_offset
		_update_scroll()


func _enter_tree():
	group_name = "__cameras_" + str(get_viewport().get_viewport_rid().get_id())
	add_to_group(group_name)
	_update_repeat()
	_update_scroll()


func _ready():
	_update_process()
	

func _process(delta):
	if in_editor && follow_viewport:
		_update_position(delta)
	if !in_editor && !ignore_camera_scroll:
		_update_position(delta)


func _update_position(delta):
	screen_offset = _calculate_screen_offset()
	autoscroll_offset += autoscroll * delta
	autoscroll_offset = autoscroll_offset.posmodv(repeat_size)
	_update_scroll()


func _exit_tree():
	remove_from_group(group_name)


func _calculate_screen_offset() -> Vector2:
	var screen_ofs : Vector2
	if Engine.is_editor_hint():
		#TODO: This is closer, but not quite there yet
		var view = EditorInterface.get_editor_viewport_2d()
		var inverse = view.get_global_canvas_transform().affine_inverse()
		var view_size = Vector2(float(view.size.x) * inverse.get_scale().x, float(view.size.y) * inverse.get_scale().y)
		screen_ofs = inverse.origin + view_size / 2
	else:
		var parent_node_2d: Node2D = get_parent() as Node2D
		if parent_node_2d:
			screen_ofs = (parent_node_2d.get_viewport_transform() * parent_node_2d.get_global_transform()).affine_inverse() * Vector2(get_viewport_rect().size / 2.0)
	return screen_ofs


func _edit_set_position(p_position : Vector2):
	if Engine.is_editor_hint():
		scroll_offset = p_position


#func _camera_moved(p_transform : Transform2D, p_screen_offset : Vector2, p_adj_screen_pos : Vector2):
	#print("updating screen offset on", name)
	#if !ignore_camera_scroll:
		#screen_offset = p_adj_screen_pos


func _update_process():
	set_process_internal(!Engine.is_editor_hint() && (repeat_size.x || repeat_size.y) && (autoscroll.x || autoscroll.y))


func _update_scroll():
	if !is_inside_tree():
		return

	var scroll_ofs : Vector2 = screen_offset
	var vps : Vector2 = get_viewport_rect().size
	
	if Engine.is_editor_hint():
		vps = Vector2(ProjectSettings.get_setting("display/window/size/viewport_width"), ProjectSettings.get_setting("display/window/size/viewport_height"))
	else:
		if (limit_begin.x <= limit_end.x - vps.x):
			scroll_ofs.x = clamp(scroll_ofs.x, limit_begin.x, limit_end.x - vps.x)
		if (limit_begin.y <= limit_end.y - vps.y):
			scroll_ofs.y = clamp(scroll_ofs.y, limit_begin.y, limit_end.y - vps.y)
	
	scroll_ofs *= scroll_scale
	
	if repeat_size.x:
		var mod : float = posmod(scroll_ofs.x - scroll_offset.x - autoscroll_offset.x, repeat_size.x)
		scroll_ofs.x = screen_offset.x - mod
	else:
		scroll_ofs.x = screen_offset.x + scroll_offset.x - scroll_ofs.x
	#
	if repeat_size.y:
		var mod : float = posmod(scroll_ofs.y - scroll_offset.y - autoscroll_offset.y, repeat_size.y)
		scroll_ofs.y = screen_offset.y - mod
	else:
		scroll_ofs.y = screen_offset.y + scroll_offset.y - scroll_ofs.y
		
	if !follow_viewport:
		scroll_ofs -= screen_offset
	
	position = scroll_ofs


func _update_repeat():
	if !is_inside_tree:
		return
	
	var repeat_scale : Vector2 = repeat_size * get_scale()
	#TODO This will need to be updated for 4.3
	#RenderingServer.canvas_set_item_mirroring(get_canvas(), get_canvas_item(), repeat_scale)
	
