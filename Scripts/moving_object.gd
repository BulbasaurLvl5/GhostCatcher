class_name MovingObject
extends Area2D


@export var shape_cast : ShapeCast2D
var motion_remainder : Vector2 = Vector2.ZERO
var rider : Actor = null
var is_pushing_rider


func move_xy(amount : Vector2):
	rider = check_for_rider()
	if rider:
		is_pushing_rider = check_rider_direction(amount)
	move_x(amount.x)
	move_y(amount.y)


func move_x(amount : float):
	motion_remainder.x += amount
	var move : int = round(motion_remainder.x)
	if(move != 0):
		if rider && is_pushing_rider:
			rider.move_x(move)
		motion_remainder.x -= move
		move_x_exact(move)
		if rider && !is_pushing_rider:
			rider.move_x(move)


func move_x_exact(amount : int):
	var step = sign(amount)
	while(amount != 0):
		shape_cast.position.x += step
		shape_cast.force_shapecast_update()
		if shape_cast.is_colliding():
			var collisions = get_collisions(Vector2(step, 0))
			if collisions && rider:
				collisions.erase(rider)
			if collisions:
				for c in collisions:
					if c is Actor:
						c.move_x(amount)
		shape_cast.position.x -= step
		position.x += step
		amount -= step


func move_y(amount : float):
	motion_remainder.y += amount
	var move : int = round(motion_remainder.y)
	if(move != 0):
		if rider && is_pushing_rider:
			rider.move_y(move)
		motion_remainder.y -= move
		move_y_exact(move)
		if rider && !is_pushing_rider:
			rider.move_y(move)


func move_y_exact(amount : int):
	var step = sign(amount)
	while(amount != 0):
		shape_cast.position.y += step
		shape_cast.force_shapecast_update()
		if shape_cast.is_colliding():
			var collisions = get_collisions(Vector2(0, step))
			if collisions && rider:
				collisions.erase(rider)
			if collisions:
				for c in collisions:
					if c is Actor:
						c.move_y(amount)
		shape_cast.position.y -= step
		position.y += step
		amount -= step


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


func check_for_rider() -> Actor:
	shape_cast.set_margin(10.0)
	var collisions = get_collisions(Vector2.ZERO)
	shape_cast.set_margin(0.0)
	if collisions:
		for c in collisions:
			if c is Player:
				if c.moving_platform == self:
					return c
	return null


func check_rider_direction(object_direction : Vector2) -> bool:
	var collisions = get_collisions(Vector2(0, -10))
	if collisions.has(rider):
		if object_direction.y < 0:
			return true
		else:
			return false
	else:
		var side = sign(rider.position.x - position.x)
		if side == sign(object_direction.x):
			return true
		else:
			return false

