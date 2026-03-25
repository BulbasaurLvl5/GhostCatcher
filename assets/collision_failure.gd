extends Node

#public enum CauseOfDeath readd if some statistiks are wanted later on ...
#{
	#pit,
	#spikes,
	#ghost,
	#skull
	#//spider, toxic gas
#}

func _ready() -> void:
	var parent: Area2D = get_parent()
	var main: Main = NodeExtention.get_child_by_type(NodeExtention.get_root(self), Main, true)
	
	parent.body_entered.connect(func(body):
		if body is Player:
			NodeExtention.instantiate(main.ui, SceneLibrary.MENU_RETRY)
		)
