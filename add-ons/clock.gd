class_name Clock
extends Node

@export var start_time: float = 0
@export var end_time: float = 1
@export var autostart: bool = false

var _running: bool = false
var _timed_signals: Array[TimedSignal]

var time: float = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	time = start_time
	if(autostart):
		_running = true
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if(_running && time < end_time):
		time += delta
		
	for t in _timed_signals:
		if time >= t.time:
			t.callable.call()
			_timed_signals.erase(t)  # einmalig auslösen
	pass
	

func start() -> void:
	_running = true
	return


func stop() -> void:
	_running = false
	return


func register_timed_callback(activation_time: float, callable: Callable) -> void:
	_timed_signals.append(TimedSignal.new(activation_time, callable))
	return


static func float_to_string(_time: float) -> String:
	return str(_time)


class TimedSignal:
	var time: float
	var callable: Callable

	func _init(_time: float, _callable: Callable):
		self.time = _time
		self.callable = _callable
