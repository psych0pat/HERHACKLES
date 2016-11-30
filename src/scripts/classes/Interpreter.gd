extends Node

var game
var owner

# TODO : un array sans args
var commands = ['help', 'get', 'set', 'connect', 'turn']

func _init(owner):
	self.owner = owner

func get(args):
	if args.size() == 1:
		var nodes = global.active_scene.get_children()
		
		# Get all elements in current scene
		if args[0] == 'elements':
			var out = "INDEX	NAME\n"
			for node in nodes:
				if 'attributes' in node:
					out += "%d		%s\n" % [node.get_index(), node.get_name()]
			return {
				'status': true,
				'message': out
			}
			
		elif owner.hacking_line != null:
			var cmd = args[0]
			if !owner.hacking_line_ref.get_ref() or !owner.hacking_line.target_ref.get_ref():
				return invalid_command('', 'Not connected')
				
			if 'attributes' in owner.hacking_line.target and\
				owner.hacking_line.target.attributes != null:
				
				# Show all attributs with read/write access (TODO : clean this mess)
				if cmd == 'attr':
					var out = "\n"
					if owner.hacking_line.target.attributes.get_all().get.size() > 0:
						out += "READ : "
						for attribut in owner.hacking_line.target.attributes.get_all().get:
							out += "%s " % attribut
						out += "\n"
						
					if owner.hacking_line.target.attributes.get_all().set.size() > 0:
						out += "WRITE : "
						for attribut in owner.hacking_line.target.attributes.get_all().set:
							out += "%s " % attribut
						out += "\n"
						
					if owner.hacking_line.target.attributes.get_all().turn.size() > 0:
						out += "TURN: on, off"
						out += "\n"
						
					return {
						'status': true,
						'message': out
					}
					
				# Read an attribut from an element
				elif cmd in owner.hacking_line.target.attributes.get_all().get:
					return {
						'message': "%s : %s\n" % [cmd, funcref(owner.hacking_line.target.attributes, "get_%s" % cmd).call_func()],
						'type': true
					}
					
		return invalid_command(args[0])
		

func turn(args):
	if !args[0] and (args[0]  != 'on' or args[0] != 'off'):
		return invalid_command(args)
		
	var on = false
	if args[0] == 'on':
		on = true
		
	return call_attr_func('set', 'on', on)

func set(args):
	if !args[0]:
		return invalid_command(args)
		
	var cmd = args[0].split('=')
	if cmd.size() != 2:
		return invalid_command(args[0], 'missing args')
	
	return call_attr_func('set', cmd[0], cmd[1])

# TODO : clean this mess
func call_attr_func(type, cmd, args=null):
	if owner.hacking_line == null or !owner.hacking_line_ref.get_ref():
		return error('not connected')
		
	if !('attributes' in owner.hacking_line.target) or\
		(!cmd in owner.hacking_line.target.attributes.get_all().set and\
		 !cmd in owner.hacking_line.target.attributes.get_all().turn):
		return error('forbidden')
	
	var out = funcref(owner.hacking_line.target.attributes, "%s_%s" % [type, cmd]).call_func(args)
	if out != null:
		return error(out)
	
	owner.hacking_line.target.hacking_effect.set_rot(-owner.hacking_line.target.get_rot())
	owner.hacking_line.target.hacking_effect.set_emitting(true)
	owner.hacking_line.get_node('sounds').play('hack')	
	
	return success("%s=%s" % [cmd, args])
	
func connect(args):
	if args.size() == 1:
		var index = args[0]
		if typeof(args[0]) == TYPE_STRING:
			index = int(args[0].strip_edges())
			
		var node = global.active_scene.get_child(index)
		if node and 'attributes' in node:
			var space_state = owner.get_world_2d().get_direct_space_state()
			var result = space_state.intersect_ray(owner.get_pos(), node.get_pos(), [owner, node], 1)
			if result.size():
				return error("cannot connect to %s : an object has cut the connection" % node.get_index())
				
			owner.connect(node)
			return success("connected to %s" % [node.get_index()])
		else:
			return error('forbidden')
	return invalid_command(args, 'missing element index')
	
func disconnect():
	# restore
	if owner.hacking_line.target_ref.get_ref():
		for attr_name in owner.hacking_line.target.attributes.initial_attr:
			funcref(owner.hacking_line.target.attributes, "set_%s" % attr_name).call_func(\
				owner.hacking_line.target.attributes.initial_attr[attr_name])
			
		return success("disconnected")
	else:
		return error("")

	
func resume(args):
	get_tree().set_pause(false)
	
func invalid_command(cmd, message=''):
	return {
		'status': false,
		'message': "Invalid command %s : %s\n" % ['`'+str(cmd)+'`', message]
	}

func error(message):
	return {
		'status': false,
		'message': "[color=red]Error : %s[/color]\n" % [message]
	}

func success(message):
	return {
		'status': true,
		'message': "[color=#7CFC00]Success : %s[/color]\n" % [message]
	}

func interpret(input):
	var input_split = input.split(' ')
	var cmd = input_split[0]
	for command in commands:
		if cmd == command:
			input_split.remove(0)
			return str(funcref(self, cmd).call_func(input_split).message)
	return invalid_command(cmd).message

func help(args):
	return {
		'status': true,
		'message':\
		"\n"+\
		" help          show this message\n"+\
		" connect [color=#1E90FF]index[/color] connect to a element\n"+\
		" set [color=#1E90FF]attr[/color]      override an attribut\n"+\
		" get [color=#1E90FF]attr[/color]      read attributs\n"+\
		" get elements  show all elements\n"+\
		" get attr      show attributs of an entity\n"+\
		" turn [color=#1E90FF]on[/color]/[color=#1E90FF]off[/color]\n"+\
		"\n"+\
		" example : \n"+\
		"  connect [color=#1E90FF]3[/color]\n"+\
		"  get attr\n"+\
		"  set [color=#00FFFF]velocity=50,0[/color]\n"+\
		"  turn [color=#00FFFF]off[/color]\n"
	}