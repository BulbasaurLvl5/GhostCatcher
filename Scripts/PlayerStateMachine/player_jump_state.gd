class_name PlayerJumpState
extends PlayerState

func Enter():
	anim.play("jump")

func _animation_finished():
	anim.play("in-air")

func Physics_Update():
	print("JUMP")
