extends CharacterBody2D


@export var move_speed: float = 200.0
@export var acceleration: float = 600.0
@export var drag: float = 250.0


func _physics_process(delta: float) -> void:
	var input: Vector2 = Input.get_vector(&"move_left", &"move_right", &"move_up", &"move_down")

	if input:
		velocity += delta * acceleration * input
		velocity = velocity.limit_length(move_speed)

	if velocity:
		velocity = velocity.move_toward(Vector2.ZERO, delta * drag)
		move_and_slide()
