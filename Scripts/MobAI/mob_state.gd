class_name MobState
extends Node

signal Transitioned


var ai : MobAI
var time_in_current_state = 0


func _ready():
	if $"../.." is MobAI:
		ai = $"../.."
	elif $"..".ai:
		ai = $"..".ai


func Initiate_Enter(from : MobState = null):
	time_in_current_state = 0
#	print(ai.name," entering ",self.name)
	Enter(from)
	
func Enter(_from : MobState):
	pass
	
func Initiate_Update(delta):
	time_in_current_state += delta
	Do_Checks(delta)
	Update(delta)
	
func Do_Checks(_delta):
	pass
	
func Update(_delta):
	pass
	
func Physics_Update(_delta):
	pass

func Initiate_Exit():
	Exit()

func Exit():
	pass

func Knockback():
	Transitioned.emit(self,"Stunned")
