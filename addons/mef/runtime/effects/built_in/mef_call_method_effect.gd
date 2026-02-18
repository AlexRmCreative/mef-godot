extends MEFEffect
class_name MEFCallMethodEffect

@export var context_key: StringName = &"instigator"
@export var method_name: StringName

func execute(context: MEFEventContext) -> void:
	var node := context.instigator

	if context_key != &"instigator":
		node = context.custom_data.get(context_key)

	if node and node.has_method(method_name):
		node.call(method_name)
