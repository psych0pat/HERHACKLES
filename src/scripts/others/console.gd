extends Panel

var input
var output
var max_commands = 15
var command_history = []
var commands = []
var n = 0

func _ready():
	input = get_node('input')
	output = get_node('output')
	output.set_scroll_follow(true)
	input.cursor_set_blink_enabled(true)
	set_process_input(true) 

func _input(event):
	if get_parent().on_console and !command_history.empty():
		if event.is_action_released('ui_up'):
			input.set_text(command_history[n])
			if command_history.size() > n + 1:
				n += 1
		elif event.is_action_released('ui_down'):
			if n - 1 >= 0:
				n -= 1
				input.set_text(command_history[n])
			else:
				input.set_text('')
			
func _on_input_text_entered(text):
	n = 0
	if command_history.size() > 5:
		command_history.pop_back()
		
	command_history.push_front(text.strip_edges())
	input.set_text('')
	if text.strip_edges() != '':
		var previous_content = output.get_bbcode()
		
		var out = global.active_scene.get_node('player').interpreter.interpret(text)
		text = "[color=#7CFC00]# [/color] %s\n" % text
		commands.append([text, out])
		var new_content = ''
		if commands.size() > max_commands:
			commands.remove(0)
		for command in commands:
			new_content += command[0] + command[1]
				
		output.set_bbcode(new_content)

