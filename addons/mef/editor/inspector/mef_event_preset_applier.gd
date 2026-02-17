extends RefCounted
class_name MEFEventPresetApplier


func apply(trigger: MEFEventTrigger, preset: MEFEventPreset) -> void:
	_clear_runtime_nodes(trigger)

	var scene_root := trigger.get_tree().edited_scene_root

	_apply_conditions(trigger, preset.conditions, scene_root)
	_apply_effects(trigger, preset.effects, scene_root)

	trigger.update_configuration_warnings()


func _apply_conditions(
	trigger: MEFEventTrigger,
	scenes: Array[PackedScene],
	scene_root: Node
) -> void:
	for scene in scenes:
		if not scene:
			continue

		var inst = scene.instantiate()
		if inst is MEFCondition:
			trigger.add_child(inst)
			inst.owner = scene_root
		else:
			inst.queue_free()
			push_error(
				"MEFEventPreset: Condition scene root must inherit from MEFCondition."
			)


func _apply_effects(
	trigger: MEFEventTrigger,
	scenes: Array[PackedScene],
	scene_root: Node
) -> void:
	for scene in scenes:
		if not scene:
			continue

		var inst = scene.instantiate()
		if inst is MEFEffect:
			trigger.add_child(inst)
			inst.owner = scene_root
		else:
			inst.queue_free()
			push_error(
				"MEFEventPreset: Effect scene root must inherit from MEFEffect."
			)


func _clear_runtime_nodes(trigger: MEFEventTrigger) -> void:
	for child in trigger.get_children():
		if child is MEFCondition or child is MEFEffect:
			trigger.remove_child(child)
			child.queue_free()


func apply_from_scene_paths(
	trigger: MEFEventTrigger,
	condition_paths: Array[String],
	effect_paths: Array[String]
) -> void:
	_clear_runtime_nodes(trigger)

	var scene_root := trigger.get_tree().edited_scene_root

	for path in condition_paths:
		var scene := load(path)
		if scene:
			var inst = scene.instantiate()
			if inst is MEFCondition:
				trigger.add_child(inst)
				inst.owner = scene_root
			else:
				inst.queue_free()

	for path in effect_paths:
		var scene := load(path)
		if scene:
			var inst = scene.instantiate()
			if inst is MEFEffect:
				trigger.add_child(inst)
				inst.owner = scene_root
			else:
				inst.queue_free()

	trigger.update_configuration_warnings()
