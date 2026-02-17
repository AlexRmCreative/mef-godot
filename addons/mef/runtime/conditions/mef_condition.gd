@icon("res://addons/mef/editor/icons/mef_condition.svg")
extends Node
class_name MEFCondition

## Return true if the event can be triggered
func is_valid(_context: MEFEventContext) -> bool:
	return true
