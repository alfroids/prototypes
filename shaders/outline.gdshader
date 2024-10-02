shader_type canvas_item;

// TODO: fix outline beyond sprite and increase directions.

uniform float outline_width: hint_range(0.0, 5.0, 1.0) = 1.0;
uniform vec4 outline_color: source_color = vec4(1.0);
uniform int resolution: hint_range(0, 100, 1) = 4;

vec2 rotate(vec2 v, float angle) {
    return vec2(
        cos(angle) * v.x - sin(angle) * v.y,
        sin(angle) * v.x + cos(angle) * v.y
    );
}

void fragment() {
	vec2 shift_distance = outline_width * TEXTURE_PIXEL_SIZE;
	float alpha = 0.0;
	
	for (int i = 0; i < resolution; i++) {
		vec2 dir = rotate(vec2(1.0, 0.0), 2.0 * PI * float(i) / float(resolution));
		vec2 uv = UV - shift_distance * dir;
		alpha += texture(TEXTURE, uv).a;
	}
	
	if (texture(TEXTURE, UV).a == 0.0)
		COLOR = outline_color;
		
	COLOR.a = alpha;
}