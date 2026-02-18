extends RefCounted
class_name MEFEventEffectRunner

signal effect_started(effect: MEFEffect, context: MEFEventContext)
signal effect_finished(effect: MEFEffect, context: MEFEventContext)
signal effect_cancelled(effect: MEFEffect, context: MEFEventContext)

func run_effects(
	effects: Array[MEFEffect],
	context: MEFEventContext
) -> void:

	# 🔹 Sort first by execution_group, then by priority
	effects.sort_custom(func(a, b):
		if a.execution_group == b.execution_group:
			return a.priority < b.priority
		return a.execution_group < b.execution_group
	)

	var executed_effects: Array[MEFEffect] = []
	
	for effect in effects:
		if context.state != MEFEventContext.EventState.RUNNING:
			_cancel_effects(executed_effects, context)
			return

		executed_effects.append(effect)

		effect_started.emit(effect, context)

		if effect.is_async():
			await effect.execute_async(context)
		else:
			effect.execute(context)

		effect_finished.emit(effect, context)

	# 🔹 Finish phase
	_finish_effects(executed_effects, context)

func _cancel_effects(
	effects: Array[MEFEffect],
	context: MEFEventContext
) -> void:
	for effect in effects:
		if effect.cancellable:
			effect.on_cancel(context)
			effect_cancelled.emit(effect, context)

func _finish_effects(
	effects: Array[MEFEffect],
	context: MEFEventContext
) -> void:
	for effect in effects:
		effect.on_finish(context)
