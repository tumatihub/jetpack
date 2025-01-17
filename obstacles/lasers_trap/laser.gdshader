shader_type canvas_item;

uniform float strength = 4.0;
uniform sampler2D noise;
uniform vec4 color: source_color;

void fragment() {
	COLOR = texture(TEXTURE,UV);
	float noise_value = texture( noise, vec2(fract(TIME), UV.x) ).r;
	if (COLOR.a < 0.01) {
		float dist_to_mid = abs(UV.y - 0.5) * 2.0;
		COLOR = vec4(color.r, color.g, color.b, strength * noise_value * (1.0 - dist_to_mid) * (1.0 - dist_to_mid) );
	}
	else {
		COLOR = color;
	}
}
