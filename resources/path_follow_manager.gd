class_name PathFollowManager
extends PathFollow2D


@export var node : Node2D
@export_range(0.0, 1.0, 0.001, "or_greater", "suffix:path cycles/second") var speed : float = 0.1
@export var pause_locations : Array[float] = [0.0, 0.5]
@export var pause_durations : Array[float] = [2.0]

var remote
var pause_remaining : float = 0


func _ready():
	if !node:
		#print(self.name," has no assigned object to carry.")
		return
	if node is MobAI:
		node.path = self
	if !get_children().has(node):
		create_remote_transform()
	if progress_ratio == 0:
		progress_ratio = 1


func create_remote_transform():
	remote = RemoteTransform2D.new()
	add_child(remote)
	remote.set_remote_node(node.get_path())

func destroy_remote_transform():
	remote.queue_free()	

func remote_transform(active : bool):
	if active:
		remote.set_update_position(true)
	else:		
		remote.set_update_position(false)


func _physics_process(delta):
	if speed != 0:
		if pause_remaining > 0:
			pause_remaining -= delta
		else:
			var from = progress_ratio
			var to = progress_ratio + (speed * delta)
			if to >= 1.0:
				to -= 1.0
			if pause_locations && pause_durations:
				to = check_progress(from, to)
			progress_ratio = to
#			print(from, "   ",to,"    ", progress_ratio)


func check_progress(from : float, to : float) -> float:
	var count : int = 0
	for l in pause_locations:
		if l == 0:
			if speed > 0 && from > 0.5 && to < 0.5:
				to = l
				start_pause(count)
			elif speed < 0 && from < 0.5 && to > 0.5:
				to = l
				start_pause(count)
		else:
			if speed > 0 && l > from && l <= to:
				to = l
				start_pause(count)
			elif speed < 0 && l < from && l >= to:
				to = l
				start_pause(count)
		count += 1
	return to


func start_pause(index : int):
	if pause_durations.size() >= index + 1:
		pause_remaining = pause_durations[index]
	else:
		pause_remaining = pause_durations[0]
