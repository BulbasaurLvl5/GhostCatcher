class_name PlayerChaser
extends Area2D


@export var chase_speed : float = 200.0
@export var idle_speed : float = 50.0
@export var time_between_turns : float = 3.0
@export var detection_range : Vector2 = Vector2(1000, 500)
var needs_line_of_sight : bool = false
@export var can_see_behind : bool = false


var facing_direction : int = 1
var player : Player
var target_path : Vector2
var is_idling : bool = true
var line_of_sight : bool = false

@onready var time_until_turn : float = time_between_turns


func _process(_delta):
	if !player:
		find_node()
	else:
		%RayCast2D.target_position = target_path
		%RayCast2D.force_raycast_update()
		if %RayCast2D.get_collider() == player:
			line_of_sight = true
		else:
			line_of_sight = false


func _physics_process(delta):
	if player:
		target_path = player.position - position 
		if can_see_player():
#			print("PLAYER SPOTTED!!!!!!!")
			is_idling = false
			time_until_turn = time_between_turns
			move_towards_player(delta)
		else:	
			is_idling = true
			time_until_turn -= delta
			idle(delta)
			
			
func can_see_player() -> bool:
	if needs_line_of_sight && !line_of_sight:
#		print("need line of sight but have none")
		return false
	if !can_see_behind && abs(target_path.x) > 500 && sign(target_path.x) != facing_direction:
#		print("can't see behind")
		return false
	if abs(target_path.x) > detection_range.x || abs(target_path.y) > detection_range.y:
#		print(target_path," is out of range of ",detection_range," from ",position)
		return false
	return true


func move_towards_player(delta):
	if facing_direction != sign(target_path.x):
		flip()
	position += Vector2.ZERO.direction_to(target_path) * chase_speed * delta


func idle(delta):
	position.x += idle_speed * facing_direction * delta
	if time_until_turn <= 0:
		flip()
		time_until_turn = time_between_turns


func flip():
	facing_direction *= -1
	scale.x *= -1


func find_node():
	var children = get_tree().root.get_children()
	for c in children:
		var grand = c.get_children()
		for g in grand:
			if g.name == "World":
				var nodes = g.get_children()
				for n in nodes:
					if n is Player:
						player = n

