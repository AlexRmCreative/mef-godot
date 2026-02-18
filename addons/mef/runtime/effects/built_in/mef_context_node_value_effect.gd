extends MEFEffect
class_name MEFSetContextNodeValueEffect

@export var key: StringName
@export var value: Node

func execute(context: MEFEventContext) -> void:
	context.custom_data[key] = value
