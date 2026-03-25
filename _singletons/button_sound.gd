extends AudioStreamPlayer

"""
connects to any button added to game
all buttons will play the same sound
"""

var sound := preload("uid://b0r8ujm2eb2vv")


func _ready() -> void:
	stream = sound
	bus = "UI"
	get_tree().node_added.connect(func(node):
		if node is Button:
			node.pressed.connect(play)
		)
	
	print("button sound singleton loaded as: "+self.name)
	return
