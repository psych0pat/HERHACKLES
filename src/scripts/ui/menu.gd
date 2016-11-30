extends Control

var toggle = true
var tween
func _ready():
	streamplayer.play_song('hacker in the dark', 0, 15)
	if get_tree().get_root().has_node('hud'):
		get_tree().get_root().get_node('hud').queue_free()
		
	global.lives = 4
	set_process_input(true)
	
func _input(event):
	if event.type == InputEvent.KEY:
		if event.scancode == KEY_RETURN && event.pressed == false:
			# get_tree().change_scene_to(global.levels[global.current_level].scene) # for debug
			get_tree().change_scene_to(global.cutscene_1)
			
			var hud = global.hud_scene.instance()
			get_tree().get_root().add_child(hud)
			
