extends  "res://scripts/classes/Entity.gd"

export(float) var rot_speed = .1
var timer
var collider
var voice

func _ready():
	attributes = global.Attributes.new(self)
	timer = get_node('timer')
	set_fixed_process(true)
	turn_on()
	
func _fixed_process(delta):
	if on and global.can_play:
		set_rot(get_rot() + rot_speed)
		if collider and timer.get_time_left() == 0:
			collider.take_damage(damage)
			timer.start()
	
func turn_on():
	on = true
	
func turn_off():
	on = false

func _on_axe_body_enter(body):
	if body.is_in_group('take_damage'):
		collider = body

func _on_axe_body_exit(body):
	if body == collider:
		collider = null
