class_name StunnedState
extends MobState


@export_range(0.0, 10.0, 0.0, "or_greater", "suffix:seconds") var stun_duration : float = 2.0
@export_range(0.0, 10.0, 0.0, "or_greater", "suffix:seconds") var knockback_duration : float = 1.0
@export_range(0.0, 500.0, 0.0, "or_greater", "suffix:pixels/second") var knockback_speed : float = 100.0

var stun_remaining : float
var knockback_remaining : float
var knockback_direction : Vector2


func Enter(_from):
	set_stun_and_knockback()
	
func set_stun_and_knockback():
	stun_remaining = stun_duration * ai.knockback_magnifier
	knockback_remaining = knockback_duration * ai.knockback_magnifier
	knockback_direction = Vector2.ZERO.direction_to(ai.position - ai.knockback_source_pos)


func Update(delta):
	stun_remaining -= delta
	knockback_remaining -= delta
	if stun_remaining <= 0:
		if ai.can_see_player():
			Transitioned.emit(self, "Chase")
		else:
			Transitioned.emit(self, "Patrol")


func Physics_Update(_delta):
	if knockback_remaining > 0:
		ai.velocity = knockback_direction * knockback_speed * knockback_remaining / knockback_duration
		ai.move_and_slide()

func Knockback():
	set_stun_and_knockback()
