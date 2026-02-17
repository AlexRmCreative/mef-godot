@tool
extends Resource
class_name MEFEventPreset

@export var conditions: Array[PackedScene] = []
@export var effects: Array[PackedScene] = []

func _get_configuration_warnings() -> PackedStringArray:
	var warnings := PackedStringArray()

	for scene in conditions:
		if not _scene_inherits(scene, &"MEFCondition"):
			warnings.append("Condition scene must inherit from MEFCondition.")
			break

	for scene in effects:
		if not _scene_inherits(scene, &"MEFEffect"):
			warnings.append("Effect scene must inherit from MEFEffect.")
			break

	return warnings

func _scene_inherits(scene: PackedScene, class_name_param: StringName) -> bool:
	if not scene:
		return false

	var inst = scene.instantiate()
	var valid := inst.is_class(class_name_param)
	inst.queue_free()
	return valid
