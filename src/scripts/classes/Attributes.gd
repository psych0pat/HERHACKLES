extends Node2D

var entity
var attr
var initial_attr = {}

func _init(entity):
	self.entity = entity
	attr = global.attr_access.get_attributes(entity)
	var hacking_effect = global.hacking_effect_scene.instance()
	self.entity.add_child(global.hacking_effect_scene.instance())
	self.entity.hacking_effect = self.entity.get_node('hacking_effect')
	self.entity.hacking_effect.set_emitting(false)
	self.entity.hacking_effect.set_pause_mode(2)
	if !attr.empty():
		for attr_name in attr.set:
			initial_attr[attr_name] = funcref(self, "get_%s" % [attr_name]).call_func()
		
	if !attr['turn'].empty():
		initial_attr['on'] = funcref(self, "get_on").call_func()
		
func get_all():
	return attr

func set_walking_speed(value):
	value = int(value)
	if value >= 0 and value <= 1000:
		self.entity.walking_speed = value
	else:
		return 'walking_speed should be smaller than 1000'

func get_walking_speed():
	return self.entity.walking_speed
	
func get_jump_strength():
	return self.entity.jump_strength
	
func set_jump_strength(value):
	value = int(value)
	if value >= 50 and value <= 1000:
		self.entity.jump_strength = value
	else:
		return 'jump_strength should be between 50 and 1000'
	
func set_hp(value):
	self.entity.hp = int(value)
	
func get_hp():
	return self.entity.hp;

func set_position(value):
	value = value.split(',')
	self.entity.set_pos(Vector2(value[0], value[1]))
	
func get_position():
	return self.entity.get_pos()
	
func set_velocity(value):
	# TODO
	value = value.split(',')
	var velocity = Vector2(value[0], value[1])
	if velocity.x <= 1000 and velocity.x >= -1000\
		and velocity.y <= 1000 and velocity.y >= -1000:
		self.entity.velocity = velocity
	else:
		return 'velocity should be between 1000 and -1000'
	
func get_velocity():
	return "%s,%s" % [self.entity.velocity.x, self.entity.velocity.y]

func set_gravity(value):
	self.entity.gravity = value
	
func get_on():
	return self.entity.on
		
func get_off():
	return !self.entity.on
	
func set_on(on = true):
	if on:
		self.entity.turn_on()
	else:
		self.entity.turn_off()

func get_gravity():
	if self.entity.gravity:
		return self.entity.gravity
	return global.gravity
	
func set_scale(value):
	value = float(value)
	if value >= 0.2 and value <= 2:
		self.entity.set_scale(Vector2(value, value))
	else:
		return 'scale should be between 0.2 and 2'
	
func get_scale():
	return self.entity.get_scale().x
	
func get_rotation():
	return self.entity.spin_velocity

func get_energy():
	return self.entity.energy
	
func set_energy(value):
	value = int(value)
	if value > 0 and value < 10:
		self.entity.turn_on(value)
	elif value == 0:
		self.entity.turn_off()