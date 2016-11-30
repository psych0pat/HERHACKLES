extends Camera2D

var shakes = 0
var shaking = false
var initial_offset 
var player_color
var player_sprite
var radius = 0
var shaking_radius = 30
var random_angle = 0
var intensity = 0.9
var length = 130
var top_limit = true
var hacking_hud

func _ready():
	if !get_parent().use_player_camera:
		clear_current()
	else:
		set_limit(2, get_tree().get_root().get_node('game').get_node('tilemap').bounds.width)
		initial_offset = Vector2(get_offset().x, get_offset().y + get_parent().camera_offset_y)
		set_offset(initial_offset)
		hacking_hud = get_tree().get_root().get_node('hud/hacking_hud')
		set_fixed_process(true)
	
func set_top_limit():
	set_limit(3, get_tree().get_root().get_node('game').get_node('tilemap').bounds.height)
	
func _fixed_process(delta):
	if is_current():
		if abs(initial_offset.length() - get_offset().length()) > 0.05 and shaking:
			radius *= intensity
			random_angle += (length +  global.random_int(-0.5, 0.5))
			var offset = Vector2(sin(random_angle) * radius , cos(random_angle) * radius)
			set_offset(initial_offset + offset)
		else:
			shaking = false
			if player_sprite:
				player_sprite.set_modulate(Color(1, 1, 1))
				
			if Input.is_action_pressed('ui_up') and !hacking_hud.on_console:
				set_offset(initial_offset + Vector2(0, -120))
			elif Input.is_action_pressed('ui_down') and !hacking_hud.on_console:
				set_offset(initial_offset + Vector2(0, 120))
			else:
				set_offset(initial_offset)
			
func shake(radius, intensity, length, change_color=true):
	var player_color = Color(8, 1, 1)
	random_angle = global.random_float(-0.5, 0.5)
	player_sprite = get_parent().get_node('sprite')
	self.radius = radius
	self.intensity = intensity
	self.length = length
	self.player_color = player_color
	if change_color:
		player_sprite.set_modulate(self.player_color)
	var offset = Vector2(sin(random_angle) * radius, cos(random_angle) * radius)
	set_offset(initial_offset + offset)
	shaking = true
	