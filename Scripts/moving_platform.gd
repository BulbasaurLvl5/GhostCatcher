class_name MovingPlatform
extends AnimatableBody2D

signal Moving


@export var path_pos : Array[Vector2]
@export var time_between_pos : float = 5.0
@export var pause_duration : float = 2.0
@export var verbose : bool = false

@onready var global_starting_pos : Vector2
@onready var target_pos_index : int = 1
@onready var target_pos : Vector2
@onready var previous_pos : Vector2
@onready var is_moving : bool = false
@onready var movement_start_time : float
@onready var type : String = "MovingPlatform"



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


func _physics_process(delta):
	var motion = Vector2.ZERO
	if is_moving:
		motion = (target_pos - previous_pos) * delta / time_between_pos
	
		
	Moving.emit(motion)
	self.move_and_collide(motion)
	


func start_moving():
	movement_start_time = Time.get_unix_time_from_system()
	is_moving = true
	