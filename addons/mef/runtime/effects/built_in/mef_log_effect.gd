extends MEFEffect
class_name MEFLogEffect

@export var log: RichTextLabel
@export var message: String = "Event executed"

func _ready():
	if log == null:
		push_error("Logger is not set for MEFLogEffect.")

func execute(context: MEFEventContext) -> void:
	if log:
		log.append_text("[color=#5ED0FF]" + message + "[/color]\n")
