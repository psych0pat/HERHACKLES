extends "res://scripts/classes/Entity.gd"

const PARAM_LINEAR_VELOCITY = 2
const PARAM_SPREAD = 1
const PARAM_DIRECTION = 0
export(Color) var line_color = Color(0, 1, 0, 1)
var gravity
var on_ground = false
var take_damage = false
var hacking_line
var hacking_line_ref
var animations
var interpreter
var velocity= Vector2()

export(int) var hp = 0

func pre_update():
	if self.gravity:
		self.velocity.y += self.gravity
	else:
		self.velocity.y += global.gravity
		
	self.velocity.x = 0
	
func post_update(motion = null):
	if self.is_colliding():
		var collider = self.get_collider()
		if collider.get_name() == 'death_area':
			self.die()
			
		if motion != null:
			var n = self.get_collision_normal()
			motion = n.slide(motion)
			self.velocity = n.slide(self.velocity)
			self.move(motion)
	
func take_damage(damage):

	take_damage = true
	self.hp -= damage
	
	if damage > 0:
		if self.get_name() == 'player':
			get_tree().get_root().get_node('hud/player_hp').set_value(self.hp)
			self.get_node('camera').shake(10, 0.70, 5)
			
		get_node('sounds').play('hit')
		
		if self.get_node('blood_particles_effect'):
			self.get_node('blood_particles_effect').set_emitting(true)
		
	if self.hp <= 0:
		self.die()

func walk(direction, walking_particles):
	var bounds = get_tree().get_root().get_node('game').get_node('tilemap').bounds
	if self.on_ground:
		walking_particles.set_param(PARAM_SPREAD, 10)
		walking_particles.set_param(PARAM_DIRECTION, -100 * direction)
		walking_particles.set_param(PARAM_LINEAR_VELOCITY, 5)
		walking_particles.set_emitting(true)
	else:
		self.walking_particles.set_emitting(false)
	
	var treshold = 20
	if self.get_pos().x < treshold and direction == -1:
		direction = 0
	elif self.get_pos().x > bounds.width - treshold and direction == 1:
		direction = 0
	self.velocity.x = self.walking_speed * direction
	
func connect(node):
	self.disconnect()
		
	if !'attributes' in node:
		return false
		
	var instance = global.hacking_line.instance()
	instance.init(self, node, Color(0, 1, 0, 1))
	self.hacking_line = instance
	self.hacking_line_ref = weakref(self.hacking_line)
	self.add_child(self.hacking_line)
	return true
	
func disconnect():
	if self.hacking_line != null and self.hacking_line_ref.get_ref():
		self.interpreter.disconnect()
		if self.hacking_line.raycast:
			self.hacking_line.raycast.queue_free()
		self.hacking_line.queue_free()

func wait():
	if self.animations.get_current_animation() != 'idle':
		self.animations.play('idle')

func jump():
	self.velocity.y = -self.jump_strength

func die():
	print(self.get_name(), ' => DIE')
	self.get_node('death_effect').set_emitting(true)
	self.animations.play('die')
