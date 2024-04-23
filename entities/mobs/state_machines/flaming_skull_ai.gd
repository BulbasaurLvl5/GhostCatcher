class_name FlyingSkullAI
extends FlyingMobAI


var rage_cooldown_remaining : float


func Update(delta):
	rage_cooldown_remaining -= delta


func can_rage_attack() -> bool:
	if rage_cooldown_remaining > 0 || !can_see_player():
		return false
	return true
