extends RefCounted
class_name MEFEvent

signal event_started(context: MEFEventContext)
signal event_finished(context: MEFEventContext)

var _effects: Array[MEFEffect] = []
var _conditions: Array[MEFCondition] = []

var _context: MEFEventContext
var _runner := MEFEventEffectRunner.new()

var _is_running := false

# -------------------------------------------------------------------
# Public API
# -------------------------------------------------------------------

func add_effect(effect: MEFEffect) -> void:
	if effect:
		_effects.append(effect)

func add_condition(condition: MEFCondition) -> void:
	if condition:
		_conditions.append(condition)

func clear() -> void:
	_effects.clear()
	_conditions.clear()

func is_running() -> bool:
	return _is_running

func cancel() -> void:
	if _context and _context.state == MEFEventContext.EventState.RUNNING:
		_context.state = MEFEventContext.EventState.CANCELLING

# -------------------------------------------------------------------
# Execution
# -------------------------------------------------------------------

func run(context: MEFEventContext) -> void:

	if _is_running:
		return

	_context = context
	_is_running = true

	# Validate conditions
	for condition in _conditions:
		if not condition.is_valid(context):
			_is_running = false
			return

	context.state = MEFEventContext.EventState.RUNNING
	event_started.emit(context)

	await _runner.run_effects(_effects, context)

	if context.state != MEFEventContext.EventState.CANCELLING:
		context.state = MEFEventContext.EventState.FINISHED

	event_finished.emit(context)

	_is_running = false
