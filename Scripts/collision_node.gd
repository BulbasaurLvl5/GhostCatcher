class_name CollisionNode
extends Area2D


var collisions : Array = []


func _ready():
	area_entered.connect(_on_area_entered)
	area_exited.connect(_on_area_exited)
	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)
	if has_overlapping_areas():
		collisions.append_array(get_overlapping_areas())
	if has_overlapping_bodies():
		collisions.append_array(get_overlapping_bodies())


func _on_area_entered(area):
	collisions.append(area)

func _on_area_exited(area):
	collisions.erase(area)

func _on_body_entered(area):
	collisions.append(area)

func _on_body_exited(area):
	collisions.erase(area)
