@tool
extends Node
class_name MEFEventTrigger

signal event_started(event: MEFEvent, context: MEFEventContext)
signal event_finished(event: MEFEvent, context: MEFEventContext)

@export var preset: MEFEventPreset:
	set(value):
		preset = value
		update_configuration_warnings()
		if Engine.is_editor_hint():
			notify_property_list_changed()

var _active_event: MEFEvent
var _node_resolver := MEFNodeResolver.new()

# -------------------------------------------------------------------
# Public API
# -------------------------------------------------------------------

func start_event(instigator: Node = null) -> void:

	# Prevent double execution
	if _active_event and _active_event.is_running():
		return

	# Build execution context
	var context := MEFEventContextFactory.from_trigger(self, instigator)

	# Create runtime event instance
	var event := MEFEvent.new()

	# Collect manual conditions (children)
	for condition in _node_resolver.get_conditions(self):
		event.add_condition(condition)

	# Collect manual effects (children)
	for effect in _node_resolver.get_effects(self):
		event.add_effect(effect)

	# If nothing configured, abort
	if event.is_empty():
		return

	_active_event = event

	# Forward signals
	event.event_started.connect(func(ctx):
		event_started.emit(event, ctx)
	)

	event.event_finished.connect(func(ctx):
		event_finished.emit(event, ctx)
		_active_event = null
	)

	await event.run(context)

func cancel_event() -> void:
	if _active_event:
		_active_event.cancel()

# -------------------------------------------------------------------
# Editor
# -------------------------------------------------------------------

func _apply_preset_internal(preset: MEFEventPreset) -> void:
	MEFEventPresetApplier.new().apply(self, preset)

func _restore_from_scene_paths(condition_paths: Array[String], effect_paths: Array[String]) -> void:
	MEFEventPresetApplier.new().apply_from_scene_paths(self, condition_paths, effect_paths)

func _get_configuration_warnings() -> PackedStringArray:

	var warnings := PackedStringArray()

	var effects := _node_resolver.get_effects(self)
	var conditions := _node_resolver.get_conditions(self)

	if effects.is_empty() and conditions.is_empty():
		warnings.append("No MEFConditions or MEFEffects configured.")

	return warnings