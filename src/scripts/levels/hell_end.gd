extends AnimationPlayer

var hades
var player

func _ready():
	hades = get_parent().get_node('hades')
	player = get_parent().get_node('player')
	
func start():
	hades.animations.play('die')
