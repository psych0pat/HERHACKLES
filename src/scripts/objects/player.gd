extends "res://scripts/classes/LivingEntity.gd"

var feet
var on_game = true
export(int) var jump_strength = 350
export(int) var walking_speed = 350
export(int) var camera_offset_y = 0
export(int) var camera_zoom = 1
export(bool) var camera_top_limit = true
export(bool) var use_player_camera = true
export(String) var text = ''
export(String) var queue_anim = ''

var sounds
var body
var walking_particles
var sprite
var feets
var walking_direction = 0 # -1:left, 0:idle, 1:right
var camera
var take_falling_damage = false
var last_position_on_ground
var alive
var direction = 0
var last_direction = 0
var death_effect

func _ready():
	hp = 8
	body = get_node('body')
	sprite = get_node('sprite')
	feets = get_node('feets')
	death_effect = get_node('death_effect')
	
	animations = sprite.get_node('animations')
	walking_particles = get_node('walking_particles')
	camera = get_node('camera')
	if !use_player_camera:
		camera.clear_current()
	if camera_top_limit and camera.is_current():
		camera.set_top_limit()
	interpreter = global.Interpreter.new(self)
	attributes = global.Attributes.new(self)
	last_position_on_ground = get_pos()
	animations.play('idle')
	
	set_fixed_process(true)

func _fixed_process(delta):
	get_node('text').set_text(text)
		
	if self.animations.get_current_animation() == 'die' and\
		self.animations.get_current_animation_pos() == self.animations.get_current_animation_length():
		self.death_trigger()
	
	if global.can_play and !get_tree().get_root().get_node('hud/hacking_hud').on_console:
		pre_update()
		direction = 0
		if Input.is_action_pressed('move_right'):
			direction = 1
			last_direction = direction
			walk(1, walking_particles)
		if Input.is_action_pressed('move_left'):
			direction = -1
			last_direction = direction
			walk(-1, walking_particles)
			
		if direction == 1 and self.animations.get_current_animation() != 'walk_right':
			self.animations.play('walk_right')
		elif direction == -1 and self.animations.get_current_animation() != 'walk_left':
			self.animations.play('walk_left')
		
		if direction == 0:
			wait()
			walking_particles.set_emitting(false)
		
		if on_ground: # updated  by `feets` node
			if take_falling_damage:
				take_falling_damage = false
				self.take_damage(int((get_pos().y - last_position_on_ground.y)/120))
				
			last_position_on_ground = get_pos()
			velocity.y += global.gravity
			if Input.is_action_pressed('jump'):
				jump()
			
			if feets.ground != null and feets.ground_ref.get_ref() and feets.ground.is_in_group('platform'):
				velocity.x += feets.ground.velocity.x
		else:
			if direction == 1 or direction == 0:
				animations.play('jump_right')
			else:
				animations.play('jump_left')
			if get_pos().y - last_position_on_ground.y > 200:
				take_falling_damage = true
			
		var motion = move(velocity * delta)
		post_update(motion)
	else:
		walking_particles.set_emitting(false)
	
	if !queue_anim.empty() and animations.get_current_animation() != queue_anim:
		animations.play(queue_anim)

	
func die():
	self.hp = 0
	get_tree().get_root().get_node('hud/player_hp').set_value(self.hp)
	get_tree().set_pause(true)
	if global.can_play:
		walking_particles.set_emitting(false)
		death_effect.set_emitting(true)
		self.get_node('camera').shake(120, 0.80, 10)
		animations.play('die')
		global.can_play = false
	
func death_trigger():
	get_tree().get_root().get_node('hud').get_node('gameover').set_hidden(false)