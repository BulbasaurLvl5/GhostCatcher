class_name PlayerIdleState
extends PlayerState

@export var actor: Player
@export var animator: AnimationPlayer

func _enter_state() -> void:
	animator.play("idle")
	
