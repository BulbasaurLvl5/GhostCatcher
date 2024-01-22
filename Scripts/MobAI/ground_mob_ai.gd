class_name GroundMobAI
extends MobAI



func Knockback(source_pos : Vector2, magnifier : float = 1):
	#Used for knockback & stun effects from player stomping
	pass


#func can_see_player() -> bool:
#	return false
	

func safe_ground_ahead() -> bool:
	return true
