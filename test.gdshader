// A Customizable Gausian Blur Shader
// Credits to DJBob Gaming YT :D
shader_type canvas_item;
uniform sampler2D SCREEN_TEXTURE : hint_screen_texture, filter_linear_mipmap;
uniform int blur_radius : hint_range(1, 32) = 8;
uniform float blur_strength : hint_range(0.1, 10.0) = 1.0;
uniform int max1_radius = 1;
uniform int max2_radius = 2;
uniform int max3_radius = 3;
uniform float max1_mix : hint_range(0.0, 0.5) = 0.1;
uniform float max2_mix : hint_range(0.0, 0.5) = 0.1;
uniform float max3_mix : hint_range(0.0, 0.5) = 0.1;
uniform float rawness : hint_range(0.0, 1.0) = 0.0;

float gaussian_weight(float i, float sigma) {
    return exp(-0.5 * (i * i) / (sigma * sigma));
}

void calculate_kernel(out float kernel[32], int radius, float sigma) {
    float sum = 0.0;
    for (int i = 0; i <= radius; i++) {
        kernel[i] = gaussian_weight(float(i), sigma);
        sum += i == 0 ? kernel[i] : 2.0 * kernel[i];
    }
    for (int i = 0; i <= radius; i++) {
        kernel[i] /= sum;
    }
}

void fragment() {
    vec2 resolution = SCREEN_PIXEL_SIZE;
    vec2 uv = SCREEN_UV;

    float kernel[32];
    calculate_kernel(kernel, blur_radius, blur_strength);

    vec3 final_color = vec3(0.0);
	vec3 max_color = vec3(0.0);
	vec3 max2_color = vec3(0.0);
	vec3 max3_color = vec3(0.0);
    float total_weight = 0.0;

    for (int x = -blur_radius; x <= blur_radius; x++) {
        for (int y = -blur_radius; y <= blur_radius; y++) {
            float weight = kernel[abs(x)] + kernel[abs(y)];
            vec2 offset = vec2(float(x), float(y)) * resolution;
			vec3 here_color = texture(SCREEN_TEXTURE, uv + offset).rgb;
            final_color += here_color * weight;
            total_weight += weight;
		}
	}
	
    for (int x = -max3_radius; x <= max3_radius; x++) {
        for (int y = -max3_radius; y <= max3_radius; y++) {
            vec2 offset = vec2(float(x), float(y)) * resolution;
			vec3 here_color = texture(SCREEN_TEXTURE, uv + offset).rgb;
			if (x*x+y*y<=max1_radius*max1_radius) {
				max_color = max(max_color, here_color);
			}
			if (x*x+y*y<=max2_radius*max2_radius) {
				max2_color = max(max2_color, here_color);
			}
			if (x*x+y*y<=max3_radius*max3_radius) {
				max3_color = max(max3_color, here_color);
			}
        }
    }

    final_color /= total_weight;
	final_color = mix(mix(mix(final_color, max_color, max1_mix), max2_color, max2_mix), max3_color, max3_mix);

	final_color = mix(final_color, texture(SCREEN_TEXTURE, uv).rgb, rawness);

    COLOR = vec4(final_color, 1.0);
}