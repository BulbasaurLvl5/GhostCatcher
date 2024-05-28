class_name ToxicGas
extends Area2D


func _on_body_entered(body):
	if !body is Player:
		return
	body.is_in_toxic_gas = true
	#print("attempted to enter toxic gas")


func _on_body_exited(body):
	if !body is Player:
		return
	body.is_in_toxic_gas = false
	
