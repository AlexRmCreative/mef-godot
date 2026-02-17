extends RefCounted
class_name MEFEventContextFactory

static func from_node(
	origin: Node,
	instigator: Node3D = null
) -> MEFEventContext:
	var context := MEFEventContext.new()
	context.instigator = instigator
	context.world = origin.get_tree().current_scene
	context.camera = origin.get_viewport().get_camera_3d()
	return context

static func from_trigger(
	trigger: Node,
	instigator: Node3D
) -> MEFEventContext:
	var context := MEFEventContext.new()
	context.trigger = trigger
	context.instigator = instigator
	context.world = trigger.get_tree().current_scene
	context.camera = trigger.get_viewport().get_camera_3d()
	return context
