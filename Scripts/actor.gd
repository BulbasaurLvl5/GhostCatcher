class_name Actor
extends Area2D


@export var shape_cast : ShapeCast2D
var motion_remainder : Vector2 = Vector2.ZERO
var momentum : Vector2 = Vector2.ZERO


func _ready():
	if shape_cast == null:
		print("ShapeCast not found on ",self)


func get_collisions(offset : Vector2) -> Array:
	var array : Array = []
	shape_cast.position += offset
	shape_cast.force_shapecast_update()
	if shape_cast.is_colliding():
		var total = shape_cast.get_collision_count()
		var count = 0
		while count < total:
			array.append(shape_cast.get_collider(count))
			count += 1
	shape_cast.position -= offset
	return array


func move_xy(amount : Vector2):
	momentum = Vector2.ZERO
	move_x(amount.x)
	move_y(amount.y)
	

func move_x(amount : float):
	motion_remainder.x += amount
	var move : int = round(motion_remainder.x)
	motion_remainder.x -= move
	momentum.x += move
	if(move != 0):
		move_x_exact(move)


func move_x_exact(amount : int):
	var step = sign(amount)
	while(amount != 0):
		shape_cast.position.x += step
		shape_cast.force_shapecast_update()
		if shape_cast.is_colliding():
			shape_cast.position.x -= step
			motion_remainder.x = 0
			amount = 0
		else:
			shape_cast.position.x -= step
			position.x += step
			amount -= step
		

func move_y(amount : float):
	motion_remainder.y += amount
	var move : int = round(motion_remainder.y)
	motion_remainder.y -= move
	momentum.y += move
	if(move != 0):
		move_y_exact(move)


func move_y_exact(amount : int):
	var step = sign(amount)
	while(amount != 0):
		shape_cast.position.y += step
		shape_cast.force_shapecast_update()
		if shape_cast.is_colliding():
			shape_cast.position.y -= step
			motion_remainder.y = 0
			amount = 0
#			print(collision_node.collisions)
		else:
			shape_cast.position.y -= step
			position.y += step
			amount -= step


func stop_motion():
	motion_remainder = Vector2.ZERO
	momentum = Vector2.ZERO
