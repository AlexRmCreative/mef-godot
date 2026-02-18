extends MEFEffect
class_name MEFPrintEffect

@export var message: String

func execute(context: MEFEventContext) -> void:
	print("[MEF]", message)
