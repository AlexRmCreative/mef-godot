extends RichTextLabel

@onready var timer: Timer = Timer.new()
var _current_event: MEFEvent

func _ready():
	add_child(timer)
	timer.one_shot = true

func _process(delta: float) -> void:
	if not timer.is_stopped():
		text = "Delay: %.2f" % timer.time_left

func _on_mef_event_trigger_event_started(event: MEFEvent, context: MEFEventContext) -> void:
	_current_event = event

	event.effect_started.connect(_on_effect_started)
	event.effect_finished.connect(_on_effect_finished)
	event.effect_cancelled.connect(_on_effect_cancelled)

func _on_mef_event_trigger_event_finished(event, context):
	if _current_event:
		_current_event.effect_started.disconnect(_on_effect_started)
		_current_event.effect_finished.disconnect(_on_effect_finished)
		_current_event.effect_cancelled.disconnect(_on_effect_cancelled)


func _on_effect_started(effect: MEFEffect, context: MEFEventContext) -> void:
	if effect.has_method("get_debug_duration"):
		timer.wait_time = effect.get_debug_duration()
		timer.start()

func _on_effect_finished(effect: MEFEffect, context: MEFEventContext) -> void:
	if effect.has_method("get_debug_duration"):
		timer.stop()
		text = "Delay: %.2f" % timer.time_left

func _on_effect_cancelled(effect: MEFEffect, context: MEFEventContext) -> void:
	if effect.has_method("get_debug_duration"):
		timer.stop()
		text = "Delay Cancelled"
