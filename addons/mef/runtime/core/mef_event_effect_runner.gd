extends RefCounted
class_name MEFEventEffectRunner


func run_effects(
	effects: Array[MEFEffect],
	context: MEFEventContext
) -> void:
	effects.sort_custom(func(a, b):
		return a.priority < b.priority
	)

	var groups := {}
	for effect in effects:
		if not groups.has(effect.execution_group):
			groups[effect.execution_group] = []
		groups[effect.execution_group].append(effect)

	var ordered_groups := groups.keys()
	ordered_groups.sort()

	var executed_effects: Array[MEFEffect] = []

	for group_id in ordered_groups:
		if context.state != MEFEventContext.EventState.RUNNING:
			_cancel_effects(executed_effects, context)
			return

		var tasks := []

		for effect in groups[group_id]:
			if context.state != MEFEventContext.EventState.RUNNING:
				_cancel_effects(executed_effects, context)
				return

			executed_effects.append(effect)

			if effect.is_async():
				tasks.append(effect.execute_async(context))
			else:
				effect.execute(context)

		for task in tasks:
			await task

	_finish_effects(executed_effects, context)


func _cancel_effects(
	effects: Array[MEFEffect],
	context: MEFEventContext
) -> void:
	for effect in effects:
		if effect.cancellable:
			effect.on_cancel(context)


func _finish_effects(
	effects: Array[MEFEffect],
	context: MEFEventContext
) -> void:
	for effect in effects:
		effect.on_finish(context)
