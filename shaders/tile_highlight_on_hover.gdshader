shader_type canvas_item;

varying flat vec2 vertex_position;
uniform bool active;
uniform vec2 tile_size;
uniform vec2 global_mouse_position;
uniform vec4 highlight_color: source_color = vec4(1.0, 0.0, 0.0, 1.0);
uniform sampler2D highlight_texture;

void vertex() {
	vertex_position = (MODEL_MATRIX * vec4(VERTEX, 0.0, 1.0)).xy;
}

void fragment() {
	if (active) {
		float is_within_x = step(vertex_position.x, global_mouse_position.x) * step(global_mouse_position.x, vertex_position.x + tile_size.x);
		float is_within_y = step(vertex_position.y, global_mouse_position.y) * step(global_mouse_position.y, vertex_position.y + tile_size.y);
		float is_within = is_within_x * is_within_y;
		
		COLOR = mix(texture(TEXTURE, UV), highlight_color, 0.5 * is_within);
	}
}