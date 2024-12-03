extends CharacterBody2D


const SPEED = 300.0

@onready var anim_player: AnimationPlayer = $AnimationPlayer as AnimationPlayer


func _physics_process(_delta: float) -> void:
	var dir: Vector2 = Input.get_vector(&"move_left", &"move_right", &"move_up", &"move_down")
	velocity = SPEED * dir

	if velocity:
		anim_player.play(&"walking")
	else:
		anim_player.play(&"idle")

	move_and_slide()
