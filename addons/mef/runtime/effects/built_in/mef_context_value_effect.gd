extends MEFEffect
class_name MEFSetContextValueEffect

@export var key: StringName
@export var value: Variant

func execute(context: MEFEventContext) -> void:
	context.custom_data[key] = value
