class_name State
extends Node
## A State class for a FSM
##
## This class handles the inputs given to the StateMachine. It can request state
## transitions by declaring variables that contain possible next states:
## [codeblock]
## @export var another_state: State
## [/codeblock]
## and calling the [method State.change_state] method.


# VARIABLES

## The State Machine this State is attached to.
var state_machine: StateMachine
##
var is_active_state: bool:
	get:
		return state_machine.active_state == self


# METHODS

## Called when this State is being activated.
func enter(_msg: Dictionary = {}) -> void:
	pass


## Called when this State is being deactivated.
func exit() -> void:
	pass


## Intended to handle input events from its [class StateMachine].
func handle_input(_event: InputEvent) -> void:
	pass


## Intended to handle idle processes from its [class StateMachine].
func update(_delta: float) -> void:
	pass


## Intended to handle physics processes from its [class StateMachine].
func physics_update(_delta: float) -> void:
	pass


## Shorthand for state transitions via the State Machine.
func change_state(new_state: State, msg: Dictionary = {}) -> void:
	if is_active_state:
		state_machine.change_state(new_state, msg)
