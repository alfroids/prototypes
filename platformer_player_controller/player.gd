extends CharacterBody2D


@export var walk_speed: float = 250.0
@export var run_speed: float = 400.0
@export var jump_speed: float = 400.0
@export var airborne_speed: float = 150.0
@export var acceleration: float = 1200.0
#@export var deceleration: float = 600.0

@onready var gravity: float = ProjectSettings.get_setting("physics/2d/default_gravity")
@onready var state_chart: StateChart = $StateChart as StateChart


# IDLE STATE

func _on_idle_state_entered() -> void:
	velocity = Vector2.ZERO


func _on_idle_state_physics_processing(_delta: float) -> void:
	var input: float = Input.get_axis(&"move_left", &"move_right")

	if input:
		if Input.is_action_pressed(&"run"):
			state_chart.send_event(&"started_running")
		else:
			state_chart.send_event(&"started_walking")

	if not is_on_floor():
		state_chart.send_event(&"started_falling")


func _on_idle_state_unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed(&"jump"):
		state_chart.send_event(&"jumped")


# WALK STATE

func _on_walk_state_physics_processing(_delta: float) -> void:
	var input: float = Input.get_axis(&"move_left", &"move_right")

	if not input:
		state_chart.send_event(&"stopped_walking")
		return

	velocity = input * walk_speed * Vector2.RIGHT
	#velocity.x = move_toward(velocity.x, input * walk_speed, delta * acceleration)
	move_and_slide()

	if not is_on_floor():
		state_chart.send_event(&"started_falling")


func _on_walk_state_unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed(&"run"):
		state_chart.send_event(&"started_running")
	elif event.is_action_pressed(&"jump"):
		state_chart.send_event(&"jumped")


# RUN STATE

func _on_run_state_physics_processing(_delta: float) -> void:
	var input: float = Input.get_axis(&"move_left", &"move_right")

	if not input:
		state_chart.send_event(&"stopped_walking")
		return

	velocity = input * run_speed * Vector2.RIGHT
	#velocity.x = move_toward(velocity.x, input * run_speed, delta * acceleration)
	move_and_slide()

	if not is_on_floor():
		state_chart.send_event(&"started_falling")


func _on_run_state_unhandled_input(event: InputEvent) -> void:
	if event.is_action_released(&"run"):
		state_chart.send_event(&"stopped_running")
	elif event.is_action_pressed(&"jump"):
		state_chart.send_event(&"jumped")


# FALL STATE

func _on_fall_state_physics_processing(delta: float) -> void:
	var input: float = Input.get_axis(&"move_left", &"move_right")
	velocity.x = input * airborne_speed
	#velocity.x = move_toward(velocity.x, input * airborne_speed, delta * acceleration)
	move_and_slide()

	velocity.y += delta * gravity

	if is_on_floor():
		state_chart.send_event(&"landed")


func _on_fall_state_unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed(&"jump"):
		state_chart.send_event(&"jumped")


# JUMP STATE

func _on_jump_state_entered() -> void:
	velocity.y = -jump_speed


func _on_jump_state_physics_processing(delta: float) -> void:
	var input: float = Input.get_axis(&"move_left", &"move_right")
	velocity.x = input * airborne_speed
	#velocity.x = move_toward(velocity.x, input * airborne_speed, delta * acceleration)
	move_and_slide()

	velocity.y += delta * gravity

	if is_on_floor():
		state_chart.send_event(&"landed")


func _on_jump_state_unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed(&"jump"):
		state_chart.send_event(&"jumped")


# DOUBLE JUMP STATE

func _on_double_jump_state_entered() -> void:
	velocity.y = -jump_speed


func _on_double_jump_state_physics_processing(delta: float) -> void:
	var input: float = Input.get_axis(&"move_left", &"move_right")
	velocity.x = input * airborne_speed
	#velocity.x = move_toward(velocity.x, input * airborne_speed, delta * acceleration)
	move_and_slide()

	velocity.y += delta * gravity

	if is_on_floor():
		state_chart.send_event(&"landed")
