shader_type canvas_item;

// Control the blink effect via script by tweening the `blink_intensity`.
// This can be achieved by using the following code:
//   ```
//   var tween: Tween = get_tree().create_tween()
//   tween.tween_method(
//       func(value: float):
//           material.set_shader_parameter("blink_intensity", value),
//       1.0, 0.0, 0.5
//   )
//   ```

uniform vec4 blink_color: source_color = vec4(1.0);
uniform float blink_intensity: hint_range(0.0, 1.0, 0.01) = 1.0;

void fragment() {
	vec4 color = texture(TEXTURE, UV);
	COLOR = mix(color, blink_color, blink_intensity * color.a);
}
