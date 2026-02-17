@icon("res://addons/mef/editor/icons/mef_event_trigger.svg")
@tool
extends Node
class_name MEFEventTrigger

signal event_started(context: MEFEventContext)
signal event_finished(context: MEFEventContext)

@export var trigger_area: Area3D:
	set(value):
		trigger_area = value
		update_configuration_warnings()

@export var preset: MEFEventPreset:
	set(value):
		preset = value
		update_configuration_warnings()

var _node_resolver := MEFNodeResolver.new()
var _preset_applier := MEFEventPresetApplier.new()

var _active_event: MEFEvent

func _ready() -> void:
	if trigger_area:
		trigger_area.body_entered.connect(_on_body_entered)

func _on_body_entered(body: Node) -> void:
	start_event(body)

# -------------------------------------------------------------------
# Public API
# -------------------------------------------------------------------

func start_event(instigator: Node3D = null) -> void:

	if not preset:
		return

	if _active_event and _active_event.is_running():
		return

	var context := MEFEventContextFactory.from_trigger(self, instigator)

	var event := MEFEventFactory.create_from_preset(
		preset,
		context,
		self
	)

	_active_event = event

	# Conectar señales ANTES de ejecutar
	event.event_started.connect(func(ctx):
		event_started.emit(ctx)
	)

	event.event_finished.connect(func(ctx):
		event_finished.emit(ctx)
		_active_event = null
	)

	await event.run(context)

# -------------------------------------------------------------------
# Editor Integration
# -------------------------------------------------------------------

func _apply_preset_internal(preset: MEFEventPreset) -> void:
	_preset_applier.apply(self, preset)


func _restore_from_scene_paths(
	condition_paths: Array[String],
	effect_paths: Array[String]
) -> void:
	_preset_applier.apply_from_scene_paths(
		self,
		condition_paths,
		effect_paths
	)


func _get_configuration_warnings() -> PackedStringArray:
	var warnings := PackedStringArray()

	if trigger_area == null:
		warnings.append("Trigger Area is not assigned.")

	if _node_resolver.get_effects(self).is_empty():
		warnings.append("MEFEventTrigger has no effects.")

	return warnings
