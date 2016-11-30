extends Control

var input
var output
var console
var timer
var camera
var on_console = false

func _ready():
	console = get_node('console')
	input = console.get_node('input')
	output = console.get_node('output')
	timer = console.get_node('timer')
	camera = get_tree().get_root()
	set_process(true)
	
func _process(delta):
	for child in global.active_scene.get_children():
		if 'attributes' in child:
			var elements_label = child.get_node('elements_label')
			elements_label.get_node('panel/label').set_text(str(child.get_index()))
			elements_label.set_rot(-child.get_rot())
	
	if get_local_mouse_pos().x > console.get_size().width:
		console.set_self_opacity(0.5)
	else:
		console.set_self_opacity(0.9)
		
	if Input.is_action_pressed('open_console') and timer.get_time_left() == 0 and global.can_play:
		timer.start()
		if on_console:
			close_console()
		else:
			open_console()

func open_console():
	#global.can_play = false
	global.active_scene.get_node('player/sprite/animations').play('get_laptop')
	global.active_scene.get_node('player/sprite/animations').queue('type')
	get_tree().call_group(0, 'indexes', 'set_hidden', false)
	on_console = true
	input.grab_focus()
	get_tree().set_pause(true)
	console.show()
	
func close_console():
	#global.can_play = true
	get_tree().call_group(0, 'indexes', 'set_hidden', true)
	on_console = false
	get_tree().set_pause(false)
	console.hide()
	
func _on_input_focus_enter():
	#global.on_console = true
	pass
	
func _on_input_focus_exit():
	pass
	
func _on_Button_pressed():
	pass # replace with function body


func _on_close_button_pressed():
	pass # replace with function body
