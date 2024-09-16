@icon("state_machine.png")
class_name StateMachine
extends Node
## A Finite State Machine class


# SIGNALS

## Emitted when the StateMachine transitions from one state to another.
signal state_changed(new_state: State)

# VARIABLES

## The state in which the StateMachine will default to.
@export var default_state: State

## The currently active state handling all inputs.
@onready var active_state: State = default_state


# METHODS

## Initializes the [param STATES] Dictionary and activates the
## [param initial state].
func _ready() -> void:
	await owner.ready

	for child in get_children():
		if child is State:
			(child as State).state_machine = self

	active_state.enter()


## Exits the currently active state and enters a new state. Emits
## [signal state_changed].
func change_state(new_state: State, msg: Dictionary = {}) -> void:
	if not new_state:
		new_state = default_state

	active_state.exit()
	active_state = new_state
	active_state.enter(msg)

	state_changed.emit(active_state)


## Intended to handle input events from its [param owner].
func handle_input(event: InputEvent) -> void:
	active_state.handle_input(event)


## Intended to handle idle processes from its [param owner].
func update(delta: float) -> void:
	active_state.update(delta)


## Intended to handle physics processes from its [param owner].
func physics_update(delta: float) -> void:
	active_state.physics_update(delta)
