class_name PlayerJumpState
extends PlayerState

func _enter_state() -> void:
	anim.play("jump")

func _animation_finished():
	anim.play("in-air")

func _physics_process(_delta):
	print("JUMP")
