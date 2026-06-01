// https://www.youtube.com/watch?v=QYGeXW4yayU

shader_type canvas_item;
uniform vec4 outline_color: source_color = vec4(0,0,0,0);
uniform bool corner_pixel = false;

void fragment() {
	vec4 base = texture(TEXTURE, UV);
	if (base.a > 0) {
		COLOR = base
	}
	else {
		vec2 image_pixel_size = TEXTURE_PIXEL_SIZE;
		bool valid_side = 
			texture(TEXTURE, UV + vec2 (-image_pixel_size.x, 0)).a > 0.0 ||
			texture(TEXTURE, UV + vec2 (image_pixel_size.x, 0)).a > 0.0 ||
			texture(TEXTURE, UV + vec2 (0, -image_pixel_size.y)).a > 0.0 ||
			texture(TEXTURE, UV + vec2 (0, image_pixel_size.y)).a > 0.0;
		bool valid_corner = 
			texture(TEXTURE, UV + vec2(-image_pixel_size.x, -image_pixel_size.y)).a > 0.0 ||
			texture(TEXTURE, UV + vec2(image_pixel_size.x, -image_pixel_size.y)).a > 0.0 ||
			texture(TEXTURE, UV + vec2(-image_pixel_size.x, image_pixel_size.y)).a > 0.0 ||
			texture(TEXTURE, UV + vec2(image_pixel_size.x, image_pixel_size.y)).a > 0.0;
	}
}


//uniform float outline_thickness: hint_range(1, 100, 0.1) = 8.0;
//uniform float anti_alias_amount = 1.0;
//uniform vec4 outline_color: source_color = vec4(1);
//
//void fragment() {
	//// Called for every pixel the material is visible on.
	//float max_distance = outline_thickness + anti_alias_amount;
	//int max_offset = int(ceil(max_distance));
	//float closest_outline_distance = max_distance;
//
	//for (int x = -max_offset; x <= max_offset; x++){
		//for (int y = -max_offset; y <= max_offset; y++) {
			//vec2 offset = vec2(float(x),float(y));
			//float dist = length(offset);
			//
			//if (dist > max_distance) continue;
			//
			//if (texture(TEXTURE, UV + offset * TEXTURE_PIXEL_SIZE).a > 0.0) {
				//closest_outline_distance = min(closest_outline_distance, dist);
			//}
		//}
	//}
	//float alpha = 1.0 - smoothstep(outline_thickness - anti_alias_amount, outline_thickness + anti_alias_amount, closest_outline_distance);
	//COLOR = vec4(outline_color.rgb, alpha);
//
//}
