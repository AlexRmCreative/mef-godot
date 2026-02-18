@tool
extends MEFEventTrigger
class_name MEFArea3DTrigger

@export var trigger_area: Area3D:
	set(value):
		trigger_area = value
		update_configuration_warnings()

func _ready() -> void:
	if trigger_area:
		trigger_area.body_entered.connect(_on_body_entered)

func _on_body_entered(body: Node) -> void:
	start_event(body)

func _get_configuration_warnings() -> PackedStringArray:
	var warnings := super()

	if not trigger_area:
		warnings.append("Trigger Area3D is not assigned.")

	return warnings
