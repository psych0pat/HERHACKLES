extends "res://scripts/classes/Entity.gd"

var rot = sign(global.random_float(-1, 1))
export(bool) var random_rot = false
export(String, FILE, '*.tscn') var destruction_effect_scene
var rot_speed = global.random_float(0.01, 0.05)
var velocity = Vector2()
	
func _ready():
	attributes = global.Attributes.new(self)
	set_fixed_process(true)
	
func _fixed_process(delta):
	if outside_map():
		destroy()
		
	if velocity.y != 0 and random_rot:
		set_rot(get_rot() + rot_speed * rot)

	if is_colliding() and get_collider() and !get_collider().is_in_group('ignore_destruction'):
		if 'take_damage' in get_collider().get_groups():
			get_collider().take_damage(damage)
			
		destroy()
	move(velocity * delta)
	
func destroy():
	var destruction_effect = load(destruction_effect_scene).instance()
	destruction_effect.set_emitting(true)
	destruction_effect.set_pos(get_pos())
	global.active_scene.add_child(destruction_effect, true)
	queue_free()
	
	

