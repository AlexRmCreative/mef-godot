extends RefCounted
class_name MEFEventFactory


func create_from_preset(
	preset: MEFEventPreset,
	context: MEFEventContext,
	scene_root: Node = null
) -> MEFEvent:

	var event := MEFEvent.new()

	# Conditions
	for scene in preset.conditions:
		if not scene:
			continue

		var inst = scene.instantiate()
		if inst is MEFCondition:
			event.add_condition(inst)
			if scene_root:
				scene_root.add_child(inst)
		else:
			inst.queue_free()
			push_error("MEFEventFactory: Condition must inherit from MEFCondition.")

	# Effects
	for scene in preset.effects:
		if not scene:
			continue

		var inst = scene.instantiate()
		if inst is MEFEffect:
			event.add_effect(inst)
			if scene_root:
				scene_root.add_child(inst)
		else:
			inst.queue_free()
			push_error("MEFEventFactory: Effect must inherit from MEFEffect.")

	return event
