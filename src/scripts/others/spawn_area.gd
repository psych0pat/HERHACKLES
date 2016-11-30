extends Node2D

var timer
var points = []
var object_scene
export(float) var randomness = 0
export(String, FILE, '*.tscn') var object_scene_name
export(Color) var color = Color(1, 1, 1, 1)
export(float) var time_between_spawn
export(Vector2) var objects_velocity
export(float) var rot_speed = 0

func _ready():
	set_fixed_process(true)
	timer = get_node('timer')
	timer.set_wait_time(time_between_spawn)
	timer.start()
	object_scene = load(object_scene_name)
	points = [
		get_node('first_point'),
		get_node('second_point')
	]

func _fixed_process(delta):
	if timer.get_time_left() == 0 and global.can_play:
		var object = object_scene.instance()
		object.set_global_pos(Vector2(\
			global.random_int(\
				points[0].get_global_pos().x,\
				points[1].get_global_pos().x\
			),\
			global.random_int(\
				points[0].get_global_pos().y,\
				points[1].get_global_pos().y\
			)\
		))
		
		object.get_node('sprite').set_modulate(color)
		
		if randomness:
			var random_scale = global.random_float(1, 1 + randomness)
			object.set_scale(Vector2(random_scale, random_scale))
			object.set_rot(object.get_rot() + global.random_float(0, 1))
			object.add_to_group('falling_objects')
		
		if 'velocity' in object:
			object.velocity = objects_velocity
		global.active_scene.add_child(object, true)
		timer.start()
