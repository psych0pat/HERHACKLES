extends  "res://scripts/classes/Entity.gd"

export(float) var initial_energy = 1.0
export(int) var initial_scale = 10
var light
var energy
var timer
var particles
var texture_scale
var animations
var speed
var fire_particles
var sounds
var voice

func _ready():
	set_fixed_process(true)
	light = get_node('light')
	timer = get_node('timer')
	particles = get_node('particles')
	fire_particles = get_node('fire_particles')
	energy = initial_energy
	texture_scale = initial_scale
	animations = get_node('animations')
	sounds = get_node('sounds')
	attributes = global.Attributes.new(self)
	timer.start()
	if on:
		turn_on()
	else:
		turn_off()
	
func random_speed():
	speed = global.random_float(2.0, 2.5)
	animations.set_speed(speed)
	timer.set_wait_time(speed/5)
	
func _fixed_process(delta):
	if on:
		if timer.get_time_left() == 0:
			random_speed()
		var n = sin((timer.get_time_left()) * 2 * PI)/global.random_int(10, 20)
		light.set_energy(energy + n)
		light.set_texture_scale(texture_scale + n)
	
func turn_off():
	sounds.stop_all()
	voice = null
	self.energy = 0
	light.set_energy(0)
	particles.set_emitting(false)
	fire_particles.set_emitting(false)
	animations.play('off')
	on = false
	
func turn_on(energy = initial_energy):
	voice = sounds.play('fire')
	self.energy = energy
	on = true
	light.set_energy(energy)
	particles.set_emitting(true)
	fire_particles.set_emitting(true)
	animations.play('burn')