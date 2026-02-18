extends MEFEffect
class_name MEFLogEffect

@export var message: String = "Event executed"

func execute(context: MEFEventContext) -> void:
	context.custom_data["log_message"] = message
