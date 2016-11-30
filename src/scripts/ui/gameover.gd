extends Control

var try_again_label
var try_again_button

func lives():
	if global.lives == 1:
		return "You have %s life left" % [global.lives]
	else:
		return "You have %s lives left" % [global.lives]

func _ready():
	try_again_label = get_node('panel/try_again_label')
	try_again_label.set_text(lives())
	try_again_button = get_node('panel/try_again_button')
	set_process(true)
	
func _process(delta):
	if global.lives == 0:
		try_again_label.set_text('No more lives !')
		try_again_button.set_disabled(true)
	

func _on_try_again_button_pressed():
	get_tree().set_pause(false)
	set_hidden(true)
	get_tree().change_scene_to(global.levels[global.current_level].scene)
	global.lives -= 1
	try_again_label.set_text(lives())
	global.can_play = true

func _on_main_menu_button_pressed():
	get_tree().set_pause(false)
	set_hidden(true)
	get_tree().get_root().get_node('hud').queue_free()
	get_tree().change_scene_to(global.menu_scene)
