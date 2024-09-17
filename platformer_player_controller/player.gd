extends CharacterBody2D


@export var walk_speed: float = 250.0
@export var run_speed: float = 400.0
@export var jump_speed: float = 400.0
@export var airborne_speed: float = 200.0
@export var acceleration: float = 1200.0
@export var friction: float = 1600.0

@onready var gravity: float = ProjectSettings.get_setting("physics/2d/default_gravity")
@onready var state_chart: StateChart = $StateChart as StateChart


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed(&"run"):
		state_chart.send_event(&"started_running")
	elif event.is_action_pressed(&"jump"):
		state_chart.send_event(&"jumped")


func handle_grounded_movement(speed: float, delta: float) -> void:
	var input: float = Input.get_axis(&"move_left", &"move_right")

	if not input:
		state_chart.send_event(&"stopped_walking")
		return

	if input * velocity.x < 0:
		velocity.x = move_toward(velocity.x, input * speed, delta * friction)
	else:
		velocity.x = move_toward(velocity.x, input * speed, delta * acceleration)

	move_and_slide()

	if not is_on_floor():
		state_chart.send_event(&"started_falling")


func handle_airborne_movement(delta: float) -> void:
	var input: float = Input.get_axis(&"move_left", &"move_right")
	velocity.x = move_toward(velocity.x, input * airborne_speed, delta * acceleration)
	move_and_slide()

	velocity.y += delta * gravity

	if is_on_floor():
		state_chart.send_event(&"landed")


# IDLE STATE

func _on_idle_state_physics_processing(delta: float) -> void:
	if velocity:
		velocity.x = move_toward(velocity.x, 0.0, delta * friction)
		move_and_slide()

	var input: float = Input.get_axis(&"move_left", &"move_right")

	if input:
		if Input.is_action_pressed(&"run"):
			state_chart.send_event(&"started_running")
		else:
			state_chart.send_event(&"started_walking")

	if not is_on_floor():
		state_chart.send_event(&"started_falling")


# WALK STATE

func _on_walk_state_physics_processing(delta: float) -> void:
	handle_grounded_movement(walk_speed, delta)


# RUN STATE

func _on_run_state_physics_processing(delta: float) -> void:
	handle_grounded_movement(run_speed, delta)


# FALL STATE

func _on_airborne_state_physics_processing(delta: float) -> void:
	handle_airborne_movement(delta)


# JUMP STATE

func _on_jump_state_entered() -> void:
	velocity.y = -jump_speed


# DOUBLE JUMP STATE

func _on_double_jump_state_entered() -> void:
	velocity.y = -jump_speed
