extends  "res://scripts/classes/Entity.gd"

var spin_velocity = 30
var animations
var collider
var timer

func _ready():
	attributes = global.Attributes.new(self)	
	animations = get_node('sprite').get_node('animations')
	timer = get_node('timer')
	animations.set_speed(global.random_float(8, 15))
	turn_on()
	set_fixed_process(true)
	
func _fixed_process(delta):
	if on and collider and timer.get_time_left() == 0:
		collider.take_damage(damage)
		timer.start()

func _on_saw_body_enter(body):
	if body.get_name() == 'player':
		collider = body
		
func _on_saw_body_exit(body):
	if body == collider:
		collider = null
	
func turn_off():
	on = false
	animations.stop()

func turn_on():
	on = true
	animations.play('on')
