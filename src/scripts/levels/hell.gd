extends "res://scripts/levels/game.gd"

var player
var hades
var princess
var old_camera_offset
var camera

func _ready():
	princess = get_node('princess')
	hades = get_node('hades')
	player = get_node('player')
	camera = get_node('camera')
	player.camera.clear_current()
	camera.make_current()
	princess.animations.play('sleep')
	._ready()
	global.can_play = false # tmp
	streamplayer.stop()
	
func hades_look():
	hades.animations.play('look')
	
func start():
	streamplayer.play_song('tango with hades', 0, 7)
	hades.wait = false
	global.can_play = true
	player.camera.set_enable_follow_smoothing(false)
	player.camera.initial_offset = camera.get_offset()
	player.camera.set_global_pos(camera.get_global_pos())
	player.camera.set_zoom(camera.get_zoom())
	camera.clear_current()
	player.camera.make_current()
	player.camera.set_enable_follow_smoothing(true)