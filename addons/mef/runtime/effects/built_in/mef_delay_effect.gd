extends MEFEffect
class_name MEFDelayEffect

@export var duration: float = 1.0

var _timer: SceneTreeTimer
var _cancelled := false

func is_async() -> bool:
	return true

func execute_async(context: MEFEventContext) -> void:
	_cancelled = false

	if not context.world:
		return

	_timer = get_tree().create_timer(duration)
	while _timer.time_left > 0:
		if _cancelled:
			return
		await get_tree().process_frame

func get_debug_duration() -> float:
	return duration

func on_cancel(context: MEFEventContext) -> void:
	_cancelled = true
