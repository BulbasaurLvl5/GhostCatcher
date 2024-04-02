class_name ParallaxClouds
extends ParallaxLayer


@export var automatic_motion : Vector2 = Vector2(-50,-10)


func _physics_process(delta):
	self.motion_offset += automatic_motion * delta
