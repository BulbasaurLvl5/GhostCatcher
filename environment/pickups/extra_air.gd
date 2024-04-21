class_name ExtraAir
extends Area2D


@export_range(1, 2, 1, "or_greater", ) var air_actions_replenished : int = 1
@export_range(0.0, 20.0, 0.01, "or_greater", "suffix:seconds") var regen_delay : float = 3.0

var timer : Timer
var recharging : bool:
	set(value):
		if recharging == value:
			return
		recharging = value
		if recharging: 
			visible = false
			timer.wait_time = regen_delay
			timer.start()
		else:
			visible = true


func _ready():
	if !timer:
		timer = Timer.new()
		add_child(timer)
		timer.one_shot = true
	if !timer.timeout.is_connected(_on_timer_timeout):
		timer.timeout.connect(_on_timer_timeout)
	if !body_entered.is_connected(_on_body_entered):
		body_entered.connect(_on_body_entered)
	
	
func _on_body_entered(body : Node2D):
	#print("body detected by ", name)
	if recharging:
		return
	if body is Player:
		#print("Player detected by ", self.name)
		body.remaining_air_actions += air_actions_replenished
		if regen_delay > 0:
			recharging = true
	#else:
		#print("Body detected by ", self.name, " but it is not")

	
func _on_timer_timeout():
	recharging = false
