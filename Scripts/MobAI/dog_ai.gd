class_name DogAI
extends GroundMobAI


var has_been_calmed : bool = false


func Knockback(source_pos : Vector2, magnifier : float = 1):
	#Used for knockback & stun effects from player stomping
	pass


#func can_see_player() -> bool:
#	return false
	

func safe_ground_ahead() -> bool:
	return true
