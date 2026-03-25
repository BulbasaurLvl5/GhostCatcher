extends Node
"""
can limit framerate. Example: 30 in menus, 60+ in game
checks input to idle: after time darkens screen, pauses game and sets fps=1
"""

# adjust
var enable_idle: bool = true
const TIME_UNTIL_IDLE: float = 30 # time/s until game enters idle

# state
var is_idling: bool = false
var last_fps: int = 0 # 0 stands for unlimited fps
var last_paused:bool = 0 # if game was alreaddy paused, revert back
var timer: float = 0

var rect: ColorRect
var label: Label
var movement_tween: Tween


func _ready():
	process_mode = Node.PROCESS_MODE_ALWAYS


func _process(delta: float) -> void:
	#print("fps: ", Engine.get_frames_per_second()) # for debugging
	
	if not is_idling and enable_idle:
		timer += delta
		if timer > TIME_UNTIL_IDLE: 
			enter_idle()
			
	if(label and randf()<.25):
		#label.anchor_left = randf_range(0.1, 0.9)
		#label.anchor_top = randf_range(0.1, 0.9)
		#label.anchor_right = randf_range(0.1, 0.9)
		#label.anchor_bottom = randf_range(0.1, 0.9)
		if not (movement_tween and movement_tween.is_running()):
			movement_tween = create_tween()
			#movement_tween.tween_property(self, "position", Vector2(randf_range(.1,.9),randf_range(.1,.9)), 4)
			movement_tween.tween_property(label, "anchor_left", randf_range(0.1, 0.9), 1)
			movement_tween.parallel().tween_property(label, "anchor_right", randf_range(0.1, 0.9), 1)
			movement_tween.parallel().tween_property(label, "anchor_top", randf_range(0.1, 0.9), 1)
			movement_tween.parallel().tween_property(label, "anchor_bottom", randf_range(0.1, 0.9), 1)
	
	return


func _input(event):
	if event.is_pressed():
		if not is_idling:
			timer = 0
		else:
			exit_idle()



func set_max_fps(fps: int) -> void:
	Engine.max_fps = fps
	return


func enter_idle() -> void:
	last_fps = int(Engine.get_frames_per_second())
	last_paused = get_tree().paused
	is_idling = true
	get_tree().paused = true
	set_max_fps(1)
	
	rect = _create_black_rect()
	label = _create_label()
	Main.ui.add_child(rect)
	Main.ui.add_child(label)
	return


func exit_idle() -> void:
	set_max_fps(last_fps)
	timer = 0
	is_idling = false
	get_tree().paused = last_paused
	if(rect):
		rect.queue_free()
	if(label):
		label.queue_free()
	return


func _create_black_rect() -> ColorRect:
	var _rect = ColorRect.new()
	_rect.color = Color.BLACK
	_rect.anchor_left = 0
	_rect.anchor_top = 0
	_rect.anchor_right = 1
	_rect.anchor_bottom = 1
	_rect.offset_left = 0
	_rect.offset_top = 0
	_rect.offset_right = 0
	_rect.offset_bottom = 0
	return _rect


func _create_label() -> Label:
	var _label = Label.new()
	_label.text = "Game is idling. \n Press key to proceed."
	
	#_label.anchor_left = 0.5
	#_label.anchor_top = 0.5
	#_label.anchor_right = 0.5
	#_label.anchor_bottom = 0.5
	_label.anchor_left = randf_range(0.1, 0.9)
	_label.anchor_top = randf_range(0.1, 0.9)
	_label.anchor_right = randf_range(0.1, 0.9)
	_label.anchor_bottom = randf_range(0.1, 0.9)

	_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	_label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	return _label
