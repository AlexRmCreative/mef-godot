extends MEFCondition
class_name MEFContextGroupCondition

@export var context_key: StringName = &"instigator"
@export var required_group: StringName = &"player"

func is_valid(context: MEFEventContext) -> bool:
	if not context:
		return false

	var node: Node = null

	if context_key == &"instigator":
		node = context.instigator
	else:
		node = context.custom_data.get(context_key)

	if not node or not node is Node:
		return false

	return node.is_in_group(required_group)
