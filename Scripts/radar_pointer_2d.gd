class_name RadarPointer2D
extends Sprite2D


var beacon : HomingBeacon2D
var beacon_active : bool = false:
	set(value):
		if value != beacon_active:
			beacon_active = value
			check_visibility()
var pointer_active : bool = false:
	set(value):
		if value != pointer_active:
			pointer_active = value
			check_visibility()
var direction : Vector2:
	set(value):
		if value != direction:
			direction = value
			update_pointer()
var radius_from_center : Vector2:
	set(value):
		if value != radius_from_center:
			radius_from_center = value
			update_pointer()
var rotates : bool = true


func check_visibility():
	if beacon_active && pointer_active:
		visible = true
	else:
		visible = false


func update_pointer():
	var factor : float
	if direction.x != 0:
		factor = radius_from_center.x / abs(direction.x)
		if abs(direction.y * factor) > radius_from_center.y:
			factor = radius_from_center.y / abs(direction.y)
	else:
		factor = radius_from_center.y
	position = direction * factor + radius_from_center + Vector2(25, 25)
	if rotates:
		rotation = Vector2.UP.angle_to(direction)


func _on_pointer_radius_changed(value : Vector2):
	radius_from_center = value

func _on_beacon_exiting_tree():
	queue_free()
