@icon("res://addons/mef/editor/icons/mef_effect.svg")
extends Node
class_name MEFEffect

@export var execution_group: MEFExecutionGroup.Group = MEFExecutionGroup.Group.MAIN
@export var priority: int = 0
@export var cancellable: bool = true

func is_async() -> bool:
	return false

func execute(_context: MEFEventContext) -> void:
	push_warning("MEFEffect.execute() not implemented in %s" % name)

func execute_async(_context: MEFEventContext) -> void:
	push_warning("MEFEffect.execute_async() not implemented in %s" % name)

func on_cancel(_context: MEFEventContext) -> void:
	pass

func on_finish(_context: MEFEventContext) -> void:
	pass

func resolve_target_node(
	context: MEFEventContext,
	explicit_target: Node
) -> Node:

	if explicit_target and is_instance_valid(explicit_target):
		return explicit_target

	if context and context.instigator and context.instigator is Node:
		return context.instigator

	return null
