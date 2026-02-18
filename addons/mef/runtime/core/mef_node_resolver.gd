extends RefCounted
class_name MEFNodeResolver


func get_conditions(root: Node) -> Array[MEFCondition]:
	var result: Array[MEFCondition] = []

	for child in root.get_children():
		if child is MEFConditionsContainer:
			for c in child.get_children():
				if c is MEFCondition:
					result.append(c)
		elif child is MEFCondition:
			result.append(child)

	return result


func get_effects(root: Node) -> Array[MEFEffect]:
	var result: Array[MEFEffect] = []
	_collect_effects(root, result)
	return result

func _collect_effects(node: Node, result: Array[MEFEffect]) -> void:
	for child in node.get_children():
		if child is MEFEffect:
			result.append(child)
		_collect_effects(child, result)
