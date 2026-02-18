extends MEFEffect
class_name MEFDelayEffect

@export var duration: float = 1.0

func is_async() -> bool:
	return true

func execute_async(context: MEFEventContext) -> void:
	if not context.world:
		return

	var timer := context.world.get_tree().create_timer(duration)
	await timer.timeout

func get_debug_duration() -> float:
	return duration