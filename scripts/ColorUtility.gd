class_name ColorUtility

static func BlendColorList(color_list):
	# r = x, g = y, b = z
	var rgb = Vector3()
	var alpha = 0
	
	# sum the color values
	for input_color in color_list:
		rgb.x += input_color.r
		rgb.y += input_color.g
		rgb.z += input_color.b
		alpha += input_color.a
	
	# RGB values are based on the square root of photon flux, so account for this when blending
	rgb *= 1.0 / color_list.size()
	
	rgb.x = pow(rgb.x, 1.0 / color_list.size())
	rgb.y = pow(rgb.y, 1.0 / color_list.size())
	rgb.z = pow(rgb.z, 1.0 / color_list.size())
	
	# alpha is linear, just get the average
	alpha *= 1.0 / color_list.size()
	return Color(rgb.x, rgb.y, rgb.z, alpha)

static func ColorToString(color):
	return "rgba(" + String.num(color.r, 3) + ", " + String.num(color.g, 3) + ", " + String.num(color.b, 3) + ", " + String.num(color.a, 3) + ")"
