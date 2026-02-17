extends MEFEffect


## Override if the effect is async
func is_async() -> bool:
	return false


## Called when the event is executed
func execute(context: MEFEventContext) -> void:
	pass


## Async effects override this
func execute_async(context: MEFEventContext) -> void:
	pass


func on_cancel(context: MEFEventContext) -> void:
	pass


func on_finish(context: MEFEventContext) -> void:
	pass
