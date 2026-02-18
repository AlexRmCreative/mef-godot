extends RefCounted
class_name MEFEventContextFactory

static func from_node(
	origin: Node,
	instigator: Node = null
) -> MEFEventContext:
	var context := MEFEventContext.new()
	context.instigator = instigator
	context.world = origin.get_tree().current_scene
	return context

static func from_trigger(
	trigger: Node,
	instigator: Node
) -> MEFEventContext:
	var context := MEFEventContext.new()
	context.trigger = trigger
	context.instigator = instigator
	context.world = trigger.get_tree().current_scene
	return context
