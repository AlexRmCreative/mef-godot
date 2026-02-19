# MEF -- Modular Event Framework (Godot 4)

MEF (Modular Event Framework) is a general-purpose modular event system
for Godot 4.

It allows you to build events composed of:

-   Conditions
-   Effects
-   Shared execution context
-   Deterministic execution order
-   Async support
-   Execution groups (EARLY / MAIN / LATE / CLEANUP)

The Core is designed to be free and extensible. Commercial modules can
be built on top of it.

------------------------------------------------------------------------

# Core Concepts

## MEFEvent

Runtime container that:

-   Validates conditions
-   Executes effects
-   Manages execution state
-   Emits lifecycle signals

Execution flow:

1.  Validate Conditions
2.  Run Effects (grouped + ordered)
3.  Handle Cancellation
4.  Finish

------------------------------------------------------------------------

## MEFCondition

Base class:

``` gdscript
extends Node
class_name MEFCondition

func is_valid(context: MEFEventContext) -> bool:
    return true
```

Used to determine whether an event can start.

------------------------------------------------------------------------

## MEFEffect

Base class:

``` gdscript
extends Node
class_name MEFEffect

@export var priority: int = 0
@export var execution_group: MEFExecutionGroup = MEFExecutionGroup.MAIN
@export var cancellable: bool = false

func execute(context: MEFEventContext) -> void:
    pass

func execute_async(context: MEFEventContext) -> void:
    pass

func on_cancel(context: MEFEventContext) -> void:
    pass

func on_finish(context: MEFEventContext) -> void:
    pass
```

Effects define the behavior of an event.

They are executed:

1.  By execution group
2.  By priority inside the group
3.  Async effects run in parallel inside the same group

------------------------------------------------------------------------

## MEFEventContext

Shared runtime data container.

Contains:

-   instigator
-   trigger
-   world
-   state
-   custom_data (Dictionary)

Used for communication between effects.

------------------------------------------------------------------------

# Quick Start

## 1. Add a MEFEventTrigger to your scene

## 2. Add Effects and Conditions as children

Example structure:

    MEFEventTrigger
     ├── MyCondition
     ├── MyEffect

## 3. Start the event

``` gdscript
$MEFEventTrigger.start_event()
```

------------------------------------------------------------------------

# Example: Simple Delay Effect

``` gdscript
extends MEFEffect
class_name MEFDelayEffect

@export var duration: float = 2.0
@export var cancellable := true

func execute(context: MEFEventContext) -> void:
    var timer := get_tree().create_timer(duration)

    while timer.time_left > 0:
        if context.state == MEFEventContext.EventState.CANCELLING:
            return
        await get_tree().process_frame
```

------------------------------------------------------------------------

# Example: Simple Condition

``` gdscript
extends MEFCondition
class_name MEFAlwaysTrueCondition

func is_valid(context: MEFEventContext) -> bool:
    return true
```

------------------------------------------------------------------------

# Using Context

Effects can share data via `context.custom_data`.

Example:

Effect A:

``` gdscript
context.custom_data["damage"] = 25
```

Effect B:

``` gdscript
var damage = context.custom_data.get("damage", 0)
```

This allows modular communication without direct references.

------------------------------------------------------------------------

# Cancellation Model

Calling:

``` gdscript
trigger.cancel_event()
```

Changes context state to CANCELLING.

Cancellable effects should check:

``` gdscript
if context.state == MEFEventContext.EventState.CANCELLING:
    return
```

CLEANUP group is always executed after cancellation.

------------------------------------------------------------------------

# Extending MEF

To create a new Effect:

1.  Extend MEFEffect
2.  Implement execute()
3.  Use context for communication
4.  Assign execution_group and priority

To create a new Condition:

1.  Extend MEFCondition
2.  Implement is_valid(context)

------------------------------------------------------------------------

# Execution Groups

-   EARLY
-   MAIN
-   LATE
-   CLEANUP

Effects are executed:

1.  Group order
2.  Priority order
3.  Async effects parallel inside group

This guarantees deterministic and modular event execution.

------------------------------------------------------------------------

# License

Core is free to use and extend.

Commercial modules can be built on top of this framework.
