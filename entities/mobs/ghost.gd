class_name Ghost
extends Area2D

var pop: AudioStreamPlayer 
var dust: GPUParticles2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pop = get_child(5) as AudioStreamPlayer
	dust = get_child(4) as GPUParticles2D
	body_entered.connect(player_collision)
	
	var anim_1 = get_child(1).get_child(0) as AnimationPlayer
	var anim_2 = get_child(1).get_child(1) as AnimationPlayer
	anim_1.seek(randf_range(0,1), true)
	anim_2.seek(randf_range(0,1), true)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
	#pass


func player_collision(body: Node2D) -> void:
	if body is Player:
		pop.reparent(get_parent()) # reparent to keep playing whle deleted
		pop.play()
		
		dust.reparent(get_parent())
		dust.emitting = true

		queue_free()
	pass
