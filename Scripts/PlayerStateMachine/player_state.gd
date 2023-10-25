class_name PlayerState
extends Node

signal state_finished

func _enter_state() -> void:
	print("entering state")
	
func _exit_state() -> void:
	print("exiting state")
