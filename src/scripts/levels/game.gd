extends Area2D

export(String, '', 'hacker in the dark', 'jazzy forest', 'tango with hades') var sound = ''
export(float) var wait_loop = 0
export(int) var db = 0

func _init():
	global.active_scene = self
	
func _ready():
	if !sound.empty():
		streamplayer.play_song(sound, wait_loop, db)
	global.active_scene.get_node('player').jump_strength = 350 # TODO
	global.active_scene = self
	global.can_play = true
	get_tree().get_root().get_node('hud/player_hp').set_value(8)