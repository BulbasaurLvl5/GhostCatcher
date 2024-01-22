class_name SkullChaseState
extends AirChaseState


@export_range(0.0, 500.0, 0.0, "or_greater", "suffix:pixels") var attack_range : float = 250.0


func Extra_Checks():
	if ai.can_rage_attack() && Vector2.ZERO.distance_to(ai.target_path) <= attack_range:
		Transitioned.emit(self, "FlamingRage")
