shader_type canvas_item;

// TODO: fix pulse to change scanline width.

uniform float scale: hint_range(0, 1000, 25) = 500;
uniform float vshift_speed: hint_range(-50.0, 50.0, 1.0) = 20.0;
uniform float pulse_speed: hint_range(0.0, 20.0, 1.0) = 5.0;

void fragment() {
	float y = scale * UV.y;
	float vshift = sin(fma(vshift_speed, TIME, y));
	float pulse_intensity = fma(0.2, fma(0.5, sin(pulse_speed * TIME), 0.5), 0.2);
	float norm_vshift = 0.5 * fma(0.5, vshift, 0.5);
	float scanline = fma((1.0 - pulse_intensity), norm_vshift, pulse_intensity);
	COLOR.a = mix(0.0, scanline, texture(TEXTURE, UV).a);
}
