extends TileMapLayer


@export var highlight_on_hover: bool = false


func _ready() -> void:
	material.set_shader_parameter(&"active", highlight_on_hover)
	material.set_shader_parameter(&"tile_size", tile_set.tile_size)


func _process(_delta: float) -> void:
	material.set_shader_parameter(&"global_mouse_position", get_global_mouse_position())
