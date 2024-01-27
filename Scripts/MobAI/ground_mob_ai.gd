class_name GroundMobAI
extends MobAI



func Knockback(source_pos : Vector2, magnifier : float = 1):
	#Used for knockback & stun effects from player stomping
	pass


#func can_see_player() -> bool:
#	return false
	

func can_step_forward(distance : float = 1.0) -> bool:
	if test_move(get_transform(), Vector2(facing_direction * distance, -2.0)):
		return false
	if !test_move(get_transform(), Vector2(facing_direction * distance, 2.0)):
		return false
	return true
