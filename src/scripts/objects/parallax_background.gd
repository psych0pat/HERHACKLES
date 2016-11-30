extends ParallaxBackground

var initial_pos
var texture_frame
var camera
export(String, FILE, '*.png') var texture_name
export(Color) var texture_modulation = Color(1, 1, 1, 1)
export(int) var offset_y = 0

func _ready():
	texture_frame = get_node('texture_frame')
	texture_frame.set_texture(load(texture_name))
	texture_frame.set_modulate(texture_modulation)
	initial_pos = Vector2(texture_frame.get_pos().x, texture_frame.get_pos().y - offset_y)
	camera = global.active_scene.get_node('player/camera')
	if !camera.is_current():
		global.active_scene.get_node('camera')
	set_process(true)
	
func _process(delta):
	texture_frame.set_modulate(texture_modulation)
	texture_frame.set_pos(initial_pos - (camera.get_camera_screen_center()/7))
