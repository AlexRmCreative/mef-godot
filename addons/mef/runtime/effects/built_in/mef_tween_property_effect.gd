extends MEFEffect
class_name MEFTweenPropertyEffect

@export var context_key: StringName = &"instigator"
@export var property: NodePath
@export var target_value: Variant
@export var duration: float = 1.0

func is_async() -> bool:
	return true

func execute_async(context: MEFEventContext) -> void:

	var node := context.instigator

	if context_key != &"instigator":
		node = context.custom_data.get(context_key)

	if not node:
		return

	var tween := node.create_tween()
	tween.tween_property(node, property, target_value, duration)

	await tween.finished
