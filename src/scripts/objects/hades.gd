extends "res://scripts/classes/LivingEntity.gd"

var player
var radar
var connect_timer
var axe_timer
var scanner = {}
var wait = true
var hp_bar
var timer
var sprite
var wait_time_after_action = 2
var action = []

func _ready():
	player = global.active_scene.get_node('player')
	radar = get_node('radar')
	connect_timer = get_node('connect_timer')
	timer = get_node('timer')
	hp_bar = get_node('hp')
	timer = get_node('timer')
	animations = get_node('sprite').get_node('animations')
	axe_timer = get_node('axe_timer')
	sprite = get_node('sprite')
	axe_timer.start()
	timer.start()
	connect_timer.start()
	animations.play('idle')
	hp_bar.set_max(hp)
	hp_bar.set_value(hp)
	interpreter = global.Interpreter.new(self)
	set_fixed_process(true)
	
func _fixed_process(delta):
	hp_bar.set_value(hp)
	if !wait:
		pre_update()
		if hp < 4:
			wait_time_after_action = 1.7
			
		if hacking_line == null or !hacking_line_ref.get_ref():
			animations.play('idle')
			
		if axe_timer.get_time_left() == 0:
			if get_parent().get_node('axe').attributes.get_scale() > 1:
				if interpreter.connect([get_parent().get_node('axe').get_index()]).status:
					interpreter.call_attr_func('set', 'scale', global.random_float(0.5, 1))
			axe_timer.start()
		elif timer.get_time_left() == 0:
			if action.size() == 0 or connect_timer.get_time_left() == 0:
				action = choose_node()
				timer.set_wait_time(0.4)
				connect_timer.start()
			elif hacking_line != null and hacking_line_ref.get_ref() and hacking_line.target_ref.get_ref():
				animations.queue('type')
				interpreter.call_attr_func('set', action[0], action[1])
				timer.set_wait_time(wait_time_after_action)
			else:
				action = []
			
			timer.start()
			
		post_update()
		
func choose_node():
	animations.play('look')
	for name in scanner:
		var entity = scanner[name]
		if entity.get_name() == 'player':
			if interpreter.connect([entity.get_index()]).status:
				return ['walking_speed', 0]
		elif entity.is_in_group('falling_objects'):
			if interpreter.connect([entity.get_index()]).status:
				return ['velocity', '%s,%s', [0, 800]]
	
	for falling_object in get_tree().get_nodes_in_group('falling_objects'):
		if interpreter.connect([falling_object.get_index()]).status:
			var angle = hacking_line.target.get_global_pos().angle_to_point(player.get_global_pos()) - PI
			var speed = global.random_int(600, 750)
			var x = sin(angle) * speed
			var y = cos(angle) * speed - global.random_int(0, 200)
			return ['velocity', "%s,%s" % [x, y]]
	
	if global.random_int(0, 2) > 0:
		for falling_object in get_tree().get_nodes_in_group('light'):
			if interpreter.connect([falling_object.get_index()]).status:
				return ['on', false]
		
		if interpreter.connect([get_parent().get_node('player').get_index()]).status:
			if bool(global.random_int(0, 1)):
				return ['jump_strength', global.random_int(50, 100)] # TODO
			return ['walking_speed', global.random_int(50, 100)]
	
	return []
	
func die():
	wait = true
	global.can_play = false
	animations.play('die')
	streamplayer.stop()
	
func red_button():
	get_parent().get_node('background_light').modulate = Color(1, 1, 1, 1)
	get_tree().change_scene_to(global.cutscene_2)

func _on_radar_body_enter(body):
	scanner[body.get_name()] = body

func _on_radar_body_exit(body):
	scanner.erase(body.get_name())
