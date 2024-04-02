class_name PathState
extends MobState


var stored_x_pos : float


func Enter(_from):
	stored_x_pos = ai.global_position.x


func Update(_delta):
	if ai.can_see_player():
		ai.path.remote_transform(false)
		Transitioned.emit(self, "Chase")
	else:
		var new_x_pos : float = ai.global_position.x
		if sign(new_x_pos - stored_x_pos) == ai.facing_direction * -1:
			ai.Flip_Mob()
		stored_x_pos = new_x_pos
