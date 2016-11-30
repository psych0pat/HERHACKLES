extends Node2D

var left_feet
var right_feet
var entity
var ground
var landing_effect
var ground_ref

func _ready():
	left_feet = get_node('left_feet')
	right_feet = get_node('right_feet')
	landing_effect = get_node('landing_effect')
	entity = get_parent()
	right_feet.add_exception(entity)
	left_feet.add_exception(entity)
	set_fixed_process(true)
	
func _fixed_process(delta):
	if left_feet.is_colliding():
		ground = left_feet.get_collider()
		landing_effect()
		entity.on_ground = true
		ground_ref = weakref(ground)
	elif right_feet.is_colliding():
		ground = right_feet.get_collider()
		landing_effect()
		ground_ref = weakref(ground)
		entity.on_ground = true
	else:
		ground = null
		entity.on_ground = false
		
func landing_effect():
	if !entity.on_ground :
		landing_effect.set_emitting(true)
		# entity.get_node('camera').shake(5, 0.5, 20, false)