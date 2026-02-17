extends Resource
class_name MEFEventContext


enum EventState {
	IDLE,
	RUNNING,
	CANCELLING,
	FINISHED
}

## Current lifecycle state of the event
var state: EventState = EventState.IDLE

## Who triggered the event (optional)
var instigator: Node3D

## Reference to the event trigger (if any)
var trigger: Node

## Usually get_tree().current_scene
var world: Node

## Active camera at trigger time (optional)
var camera: Camera3D

## Free-form data shared between effects and conditions
@export var custom_data := {}
