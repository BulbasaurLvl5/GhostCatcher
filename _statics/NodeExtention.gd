extends Object
class_name NodeExtention


static func get_root(node: Node) -> Node:
	return node.get_node("/root")


static func get_nested_children(node: Node) -> Array[Node]:
	var children: Array[Node] = node.get_children()
	var nested_children: Array[Node]
	
	while children.size() > 0:
		var child = children[0]
		nested_children.append(child)
		children.append_array(child.get_children())
		children.erase(child)
	
	return nested_children


static func get_child_by_type(node: Node, type: Variant, include_nested: bool = false) -> Node:
	var children = get_nested_children(node) if include_nested else node.get_children()
	
	for child in children:
		if type is GDScript and child.get_script() == type:
			return child
	
		elif type is String and type == child.get_class():
			return child
	return null


static func get_children_by_type(node: Node, type: Variant, include_nested: bool = false) -> Array[Node]:
	var children = get_nested_children(node) if include_nested else node.get_children()
	var typed_children: Array[Node]
	
	for child in children:
		if type is GDScript and child.get_script() == type:
			typed_children.append(child)
	
		elif type is String and type == child.get_class():
			typed_children.append(child)
	
	return typed_children


static func instantiate(parent: Node, scene: PackedScene, position: Vector2 = Vector2(0,0), rotation_degree: float = 0, scale: Vector2 = Vector2(1,1), skew_degree: float = 0):
	var instance: Node = scene.instantiate()
	var inst2D: Node2D = instance as Node2D
	if inst2D:
		instance.set_position(position)
		instance.set_rotation(rotation_degree * (PI / 180))
		instance.set_scale(scale)
		instance.set_skew(skew_degree * (PI / 180))
	
	parent.add_child(instance)
	return instance
