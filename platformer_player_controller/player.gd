extends CharacterBody2D


@export var walk_speed: float = 250.0
@export var run_speed: float = 400.0
@export var jump_speed: float = 400.0

@onready var gravity: float = ProjectSettings.get_setting("physics/2d/default_gravity")
@onready var state_chart: StateChart = $StateChart as StateChart


func _physics_process(_delta: float) -> void:
	if velocity:
		move_and_slide()


# IDLE STATE

func _on_idle_state_physics_processing(_delta: float) -> void:
	var input: float = Input.get_axis(&"move_left", &"move_right")

	if input:
		if Input.is_action_pressed(&"run"):
			state_chart.send_event(&"started_running")
		else:
			state_chart.send_event(&"started_walking")


# WALK STATE

func _on_walk_state_physics_processing(_delta: float) -> void:
	var input: float = Input.get_axis(&"move_left", &"move_right")

	if not input:
		state_chart.send_event(&"stopped_walking")

	if Input.is_action_pressed(&"run"):
		state_chart.send_event(&"started_running")

	velocity.x = input * walk_speed


# RUN STATE

func _on_run_state_physics_processing(_delta: float) -> void:
	var input: float = Input.get_axis(&"move_left", &"move_right")

	if not input:
		state_chart.send_event(&"stopped_walking")

	if not Input.is_action_pressed(&"run"):
		state_chart.send_event(&"stopped_running")

	velocity.x = input * run_speed


# GROUND STATE

func _on_ground_state_unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed(&"jump"):
		state_chart.send_event(&"jumped")


func _on_ground_state_physics_processing(_delta: float) -> void:
	if not is_on_floor():
		state_chart.send_event(&"started_falling")


# FALL STATE

func _on_fall_state_unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed(&"jump"):
		state_chart.send_event(&"jumped")


func _on_fall_state_physics_processing(delta: float) -> void:
	if is_on_floor():
		state_chart.send_event(&"hit_ground")

	velocity.y += delta * gravity


# JUMP STATE

func _on_jump_state_entered() -> void:
	velocity.y = -jump_speed


func _on_jump_state_unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed(&"jump"):
		state_chart.send_event(&"jumped")


func _on_jump_state_physics_processing(delta: float) -> void:
	if is_on_floor():
		state_chart.send_event(&"hit_ground")

	velocity.y += delta * gravity


# DOUBLE JUMP STATE

func _on_double_jump_state_entered() -> void:
	velocity.y = -jump_speed


func _on_double_jump_state_physics_processing(delta: float) -> void:
	if is_on_floor():
		state_chart.send_event(&"hit_ground")

	velocity.y += delta * gravity
