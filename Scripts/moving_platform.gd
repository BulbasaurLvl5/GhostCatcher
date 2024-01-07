class_name MovingPlatform
extends AnimatableBody2D



@export var path_pos : Array[Vector2]
@export var time_between_pos : float = 5.0
@export var pause_duration : float = 2.0
@export var verbose : bool = false

var global_starting_pos : Vector2
var target_pos_index : int = 1
var target_pos : Vector2
var previous_pos : Vector2
var is_moving : bool = false
var movement_start_time : float
var stored_motion : Vector2 = Vector2.ZERO
var type : String = "MovingPlatform"


func _ready():
	global_starting_pos = position
	previous_pos = path_pos[0] + global_starting_pos
	target_pos = path_pos[1] + global_starting_pos
	movement_start_time =Time.get_unix_time_from_system()
	is_moving = true


func _process(_delta):
	if is_moving && Time.get_unix_time_from_system() >= movement_start_time + time_between_pos:
		is_moving = false
		previous_pos = target_pos
		target_pos_index += 1
		if target_pos_index > path_pos.size() - 1:
			target_pos_index = 0
		target_pos = path_pos[target_pos_index] + global_starting_pos
		
		$PauseTimer.start(pause_duration)


#func _physics_process(delta):
#	var motion = stored_motion
#	if is_moving:
#		stored_motion = (target_pos - previous_pos) * delta / time_between_pos
#	else:
#		stored_motion = Vector2.ZERO	
#	Moving.emit(stored_motion)
#	self.move_xy(motion)


func start_moving():
	movement_start_time = Time.get_unix_time_from_system()
	is_moving = true
	
