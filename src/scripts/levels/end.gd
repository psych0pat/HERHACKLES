extends Control

var player
var streamer
var credits
var princess
var end = false

func _ready():
	if get_tree().get_root().has_node('hud'):
		get_tree().get_root().get_node('hud').queue_free()
	global.can_play = false
	credits = get_node('credits')
	player = credits.get_node('player')
	princess = credits.get_node('princess')
	get_node('camera').make_current()
	streamer = get_node('streamer')
	set_process(true)

func _process(delta):
	if end:
		credits.move(Vector2(0, -20) * delta)
	
func end():
	end = true
	streamer.play()
	
func princess_glitch():
	princess.animations.play('glitch')
	
func connect():
	player.connect(princess)
	
func reboot():
	princess.set_hidden(true)
	princess.animations.play('idle')

func _on_streamer_finished():
	get_tree().change_scene_to(global.menu_scene)
