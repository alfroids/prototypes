shader_type canvas_item;

// Control the dissolve effect via script by tweening the `dissolve_intensity`.
// This can be achieved by using the following code:
//   ```
//   var tween: Tween = get_tree().create_tween()
//   tween.tween_method(
//       func(value: float):
//           material.set_shader_parameter("dissolve_intensity", value),
//       0.0, 1.0, 1.0
//   )
//   ```
// NOTE: the result might not be as expected if the object is moving!

uniform sampler2D noise;
uniform float dissolve_intensity: hint_range(0.0, 1.0, 0.01) = 0.5;
uniform vec4 lining_color: source_color = vec4(1.0);
uniform float lining_intensity: hint_range(0.0, 1.0, 0.01) = 0.02;

void fragment() {
	if (texture(noise, SCREEN_UV).r <= dissolve_intensity - lining_intensity)
		COLOR.a = 0.0;
	else if (texture(noise, SCREEN_UV).r <= dissolve_intensity) {
		float alpha = COLOR.a;
		COLOR = lining_color;
		COLOR.a *= alpha;
	}
}
