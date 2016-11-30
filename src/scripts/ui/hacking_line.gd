extends TextureFrame

export(NodePath) var export_target
export(bool) var add_raycast = true
export(bool) var visible = true

var source
var source_ref
var target
var target_ref
var hacking_effect
var raycast

func init(source, target, color):
	get_material().set_shader_param('line_color', color)
	self.source = source
	self.target = target
	self.source_ref = weakref(self.source)
	self.target_ref = weakref(self.target)

func _ready():
	if typeof(export_target) != TYPE_NIL and !export_target.is_empty():
		self.init(get_parent(), get_node(export_target), Color(0, 1, 0, 1))
	
	hacking_effect = get_node('hacking_effect')
	if add_raycast:
		raycast = get_node('raycast')
		raycast.add_exception(source)
		raycast.add_exception(target)
	set_fixed_process(true)
	set_process(true)


func _fixed_process(delta):
	if typeof(export_target) != TYPE_NIL and !export_target.is_empty():
		self.init(get_parent(), get_node(export_target), Color(0, 1, 0, 1))
		
	if target_ref != null and !target_ref.get_ref():
		source.disconnect()
	
	if add_raycast and raycast and raycast.is_colliding():
		source.disconnect()
		
	if source and target and source_ref.get_ref() and target_ref.get_ref():
		var dx = target.get_pos().x - source.get_pos().x
		var dy = target.get_pos().y - source.get_pos().y 
		if add_raycast:
			raycast.set_cast_to(Vector2(dx, dy))
			raycast.set_layer_mask(1)

func _process(delta):
	update()

func _draw():
	if visible and source and target and source_ref.get_ref() and target_ref.get_ref():
		var angle = source.get_angle_to(target.get_pos())
		#var x = source.get_pos().x
		#var y = source.get_pos().y
		var window_size = get_viewport().get_rect().size
		#var camera = global.active_scene.get_node('player').get_node('camera')
		#var tmp_x = camera.get_camera_screen_center().x + (get_viewport_rect().size.x * camera.get_zoom().x)/2
		#if tmp_x < source.get_pos().x:
		#	x = tmp_x
		#	y = angle * x
			
		var dx = target.get_pos().x - source.get_pos().x
		var dy = target.get_pos().y - source.get_pos().y
		get_material().set_shader_param('window_size', get_viewport().get_rect().size)
		get_material().set_shader_param('angle',  angle)
		
		draw_line(Vector2(0, 0), Vector2(dx, dy), Color(1, 1, 1), 4)
	
