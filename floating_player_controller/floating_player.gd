extends CharacterBody2D


@export var move_speed: float = 200.0
@export var acceleration: float = 600.0
@export var drag: float = 250.0

@onready var sprite_2d: Sprite2D = $Sprite2D as Sprite2D


func _physics_process(delta: float) -> void:
	var input: Vector2 = Input.get_vector(&"move_left", &"move_right", &"move_up", &"move_down")

	if input:
		velocity += delta * acceleration * input
		velocity = velocity.limit_length(move_speed)

	if velocity:
		velocity = velocity.move_toward(Vector2.ZERO, delta * drag)

	if not velocity:
		sprite_2d.frame_coords = Vector2(0, 0)
	else:
		var x: int = 1 if velocity.x > move_speed / 4 else 2 if velocity.x < -move_speed / 4 else 0
		var y: int = 1 if velocity.y < -move_speed / 4 else 2 if velocity.y > move_speed / 4 else 0
		sprite_2d.frame_coords = Vector2(x, y)
		move_and_slide()
