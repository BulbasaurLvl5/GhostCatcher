class_name MobAI
extends CharacterBody2D


@export var facing_direction : int = 1
@export_range(0.0, 2000.0, 0.01, "or_greater", "suffix:pixels") var vision_ahead : float = 1000.0
@export_range(0.0, 2000.0, 0.01, "or_greater", "suffix:pixels") var vision_behind : float = 300.0
@export_range(0.0, 2000.0, 0.01, "or_greater", "suffix:pixels") var vision_above : float = 300.0
@export_range(0.0, 2000.0, 0.01, "or_greater", "suffix:pixels") var vision_below : float = 300.0
@export var x_ray_vision : bool = true

var path : PathFollowManager
var player : Player
var target_path : Vector2
var knockback_source_pos : Vector2
var knockback_magnifier : float = 1.0
var current_hesitation : float = 0.0


func _ready():
	if !player:
		find_node()


func _process(delta):
	current_hesitation -= delta
	if !player:
		find_node()
	else:
		target_path = player.position - global_position
	Update(delta)


func Update(_delta):
	pass


func find_node():
	var children = find_all_children(get_tree().root)
	for c in children:
		if c is Player:
			player = c


func can_see_player() -> bool:
	if !player:
		return false
	if !x_ray_vision && !has_line_of_sight():
		return false
		
	if sign(target_path.x) == facing_direction:
		if abs(target_path.x) > vision_ahead:
			return false
	elif abs(target_path.x) > vision_behind:
			return false
			
	if target_path.y < 0:
		if abs(target_path.y) > vision_above:
			return false
	elif target_path.y > vision_below:
			return false
			
	return true
	
	
func has_line_of_sight() -> bool:
	if !player:
		return false
	%RayCast2D.target_position = target_path
	%RayCast2D.force_raycast_update()
	if %RayCast2D.get_collider() == player:
		return true
	return false


func Knockback(source_pos : Vector2, magnifier : float = 1.0):
#	print(self.name," received KNOCKBACK!    ")
	knockback_source_pos = source_pos
	knockback_magnifier = magnifier
	%StateMachine.current_state.Knockback()


func Flip_Mob():
	facing_direction *= -1
#	anim.scale.x *= -1


func find_all_children(parent : Node) -> Array:
	var all = []
	var children = parent.get_children()
	all.append_array(children)
	for c in children:
		all.append_array(find_all_children(c))
	return all
