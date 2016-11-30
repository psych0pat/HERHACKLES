extends "res://scripts/classes/Entity.gd"

export(Vector2) var velocity = Vector2(0, 0)

func _ready():
	attributes = global.Attributes.new(self)
	set_fixed_process(true)

func _fixed_process(delta):
	velocity.y = 0
	if outside_map():
		destroy()
	
	if is_colliding() and(\
		get_collider().get_parent().get_name() == global.tilemap_name or\
		get_collider().is_in_group('platform')):
		velocity.x = -velocity.x
		
	move(velocity * delta)