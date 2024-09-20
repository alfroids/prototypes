extends Node2D


@export_enum("Platformer", "Floating") var player_type: int = 0

@onready var player_scenes: Array[PackedScene] = [
	preload("res://platformer_player_controller/platformer_player.tscn"),
	preload("res://floating_player_controller/floating_player.tscn"),
]


func _ready() -> void:
	var player: CharacterBody2D = player_scenes[player_type].instantiate() as CharacterBody2D
	add_child(player)
	var camera: Camera2D = Camera2D.new()
	camera.process_callback = Camera2D.CAMERA2D_PROCESS_PHYSICS
	camera.position_smoothing_enabled = true
	player.add_child(camera)
