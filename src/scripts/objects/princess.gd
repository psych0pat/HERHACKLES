extends KinematicBody2D

var sprite
var animations

func _ready():
	set_fixed_process(true)
	sprite = get_node('sprite')
	animations = sprite.get_node('animations')
	
func _fixed_process(delta):
	pass