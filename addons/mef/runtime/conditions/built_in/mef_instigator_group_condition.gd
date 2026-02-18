extends MEFCondition
class_name MEFInstigatorGroupCondition

@export var required_group: StringName = &"player"

func is_valid(context: MEFEventContext) -> bool:

	if not context or not context.instigator:
		return false

	return context.instigator.is_in_group(required_group)
