class_name DogAI
extends GroundMobAI


@export_range(0.0, 2000.0, 1.0, "or_greater", "suffix:pixels") var pet_range : float = 50.0
@export_range(0.0, 2000.0, 1.0, "or_greater", "suffix:pixels") var bark_distance_min : float = 400.0
@export_range(0.0, 2000.0, 1.0, "or_greater", "suffix:pixels") var bark_distance_max : float = 700.0


var has_been_calmed : bool = false
var is_running_from_dead_end : bool = false
var is_barking : bool = false


func bark(active : bool = true):
	if active && !is_barking:
		is_barking = true
		$SFX/Bark.start()
	elif !active && is_barking:
		is_barking = false
		$SFX/Bark.stop()


func Knockback(_source_pos : Vector2, _magnifier : float = 1):
	#Used for knockback & stun effects from player stomping
	pass


#func can_see_player() -> bool:
#	return false
	

func safe_ground_ahead() -> bool:
	return true
