extends RichTextLabel

var _current_event: MEFEvent

func _on_mef_event_trigger_event_started(event: MEFEvent, context: MEFEventContext) -> void:
	clear()
	_current_event = event
	event.effect_started.connect(_on_effect_started)

func _on_mef_event_trigger_event_finished(event: MEFEvent, context: MEFEventContext) -> void:
	if context.state == MEFEventContext.EventState.CANCELLING:
		clear()
		append_text("[color=red]CANCELLED[/color]\n")
	else:
		append_text("[color=green]FINISHED[/color]\n")

	if _current_event:
		_current_event.effect_started.disconnect(_on_effect_started)

	_current_event = null

func _on_effect_started(effect: MEFEffect, context: MEFEventContext) -> void:
	if effect is MEFLogEffect:
		append_text("[color=#5ED0FF]%s[/color]\n" % effect.message)

