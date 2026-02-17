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

	for child in root.get_children():
		if child is MEFEffectsContainer:
			for e in child.get_children():
				if e is MEFEffect:
					result.append(e)
		elif child is MEFEffect:
			result.append(child)

	return result
