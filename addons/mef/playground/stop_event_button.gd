extends Button

@export var trigger: MEFEventTrigger

func _ready() -> void:
	if trigger == null:
		push_error("Trigger is not set for the button.")

func _on_pressed() -> void:
	trigger.cancel_event()
