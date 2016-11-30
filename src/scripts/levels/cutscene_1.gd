extends Area2D

var camera
var princess
var player

func _init():
	global.active_scene = self
	
func _ready():
	streamplayer.stop()
	global.can_play = false
	camera = get_node('camera')
	camera.make_current()
	princess = get_node('princess')
	get_node('animations').play('main')
	set_process(true)
	
func _process(delta):
	if !get_node('animations').is_playing():
		global.can_play = true
		get_tree().change_scene_to(global.levels[global.current_level].scene)
	
# Call Func
func day():
	get_node('torch').turn_off()