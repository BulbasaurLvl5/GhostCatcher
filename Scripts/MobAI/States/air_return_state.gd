class_name AirReturnState
extends MobState


@export_range(0.0, 1000.0, 1.0, "or_greater", "suffix:pixels/second") var return_speed : float = 200.0
@export var mob_size : Vector2 = Vector2(100.0, 100.0)

var warp_check_delay : float = 0.1
var visibility_self : VisibleOnScreenNotifier2D
var visibility_path : VisibleOnScreenNotifier2D


func Enter(_from):
	visibility_self = VisibleOnScreenNotifier2D.new()
	visibility_path = VisibleOnScreenNotifier2D.new()
	ai.add_child(visibility_self)
	ai.path.add_child(visibility_path)
	visibility_self.set_rect(Rect2(-mob_size.x, -mob_size.y, 2 * mob_size.x, 2 * mob_size.y))
	visibility_path.set_rect(Rect2(-mob_size.x, -mob_size.y, 2 * mob_size.x, 2 * mob_size.y))
	warp_check_delay = 0.1


func Update(delta):
	if ai.can_see_player():
		Transitioned.emit(self, "Chase")
	elif ai.position.distance_to(ai.path.position) <= return_speed * delta:
		ai.path.remote_transform(true)
		Transitioned.emit(self, "Path")
	elif warp_check_delay <= 0:
		if can_warp_safely():
			warp_to_path()
		warp_check_delay = 0.1
	else:
		warp_check_delay -= delta


func Physics_Update(_delta):
	ai.velocity = ai.position.direction_to(ai.path.position) * return_speed
	if sign(ai.velocity.x) == ai.facing_direction * -1:
		ai.Flip_Mob()
	ai.move_and_slide()
	

func can_warp_safely() -> bool:
	if !visibility_self.is_on_screen() && !visibility_path.is_on_screen():
		return true
	return false

func warp_to_path():
	ai.path.remote_transform(true)
	Transitioned.emit(self, "Path")


func Exit():
	visibility_self.queue_free()
	visibility_path.queue_free()
