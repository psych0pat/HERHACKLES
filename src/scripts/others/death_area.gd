extends Area2D

func _ready():
	pass

func _on_death_area_body_enter(body):
	if body.has_method('die'):
		body.die()
	
