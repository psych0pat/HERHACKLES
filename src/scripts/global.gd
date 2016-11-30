extends Node

var attr_access = preload('res://scripts/others/attr_access.gd')

# Scenes
var main_scene = preload('res://scenes/main.tscn')
var menu_scene = preload('res://scenes/levels/menu.tscn')
var hud_scene = preload("res://scenes/hud/hud.tscn")
var elements_label_scene = preload("res://scenes/hud/elements_label.tscn")
var rock_scene = preload("res://scenes/objects/rock.tscn")
var gameover_scene = preload('res://scenes/hud/gameover.tscn')
var cutscene_1 = preload("res://scenes/levels/cutscene_1.tscn")
var cutscene_2 = preload("res://scenes/levels/end.tscn")

# Effect scenes
var set_effect_scene = preload("res://scenes/effects/set_effect.tscn")
var landing_effect_scene = preload("res://scenes/effects/landing_effect.tscn")
var falling_object_destruction_effect_scene = preload("res://scenes/effects/falling_object_destruction_effect.tscn")
var hacking_effect_scene = preload("res://scenes/effects/hacking_effect.tscn")

# HUD
var hacking_line = preload("res://scenes/hud/hacking_line.tscn")

# Classes
var Attributes = preload('res://scripts/classes/Attributes.gd')
var Interpreter = preload('res://scripts/classes/Interpreter.gd') 

# Levels
var levels = {
	'city_1': {
		'scene': preload('res://scenes/levels/city_1.tscn'),
		'elements': {
			'player': {
				'get': ['jump_strength'],
				'set': ['jump_strength']
			}
		 }
	},
	'grass_1': {
		'scene': preload('res://scenes/levels/grass_1.tscn'),
		'elements': {
			'bird': {
				'get': ['velocity'],
				'set': ['velocity']
			}
		}
	},
	'grass_2': {
		'scene': preload('res://scenes/levels/grass_2.tscn'),
		'elements': {
			'moving_platform': {
				'get': ['velocity'],
				'set': ['velocity']
			}
		}
	},
	'cave_1': {
		'scene': preload('res://scenes/levels/cave_1.tscn'),
		'elements': {
			'torch': {
				'turn': ['on', 'off'],
				'set': ['scale']
			}
		}
	},
	'cave_2': {
		'scene': preload('res://scenes/levels/cave_2.tscn'),
		'elements': {
			'saw': {
				'turn': ['on', 'off']
			}, 
			'axe': {
				'turn': ['on', 'off']
			},
			'player': {
				'get': ['jump_strength'],
				'set': ['jump_strength']
			}
		}
	},
	'hell': {
		'scene': preload('res://scenes/levels/hell.tscn'),
		'elements': {
			'player': {
				'get': ['walking_speed', 'jump_strength'],
				'set': ['walking_speed', 'jump_strength']
			},
			'rock': {
				'get': ['velocity', 'scale'],
				'set': ['velocity', 'scale']
			}, 
			'torch': {
				'turn': ['on', 'off']
			},
			'hades': {
				'get': ['hp']
			},
			'axe': {
				'turn': ['on', 'off'],
				'get': ['scale'],
				'set': ['scale']
			}
		}
	}
}

# Global var & function
var tilemap_name = 'tilemap'
var gravity = 15
var on_console = false
var current_level = 'city_1'
var active_scene
var camera
var can_play = true
var lives

func random_int(start, end):
	randomize()
	return int(rand_range(start, end))
	
func random_float(start, end):
	randomize()
	return rand_range(start, end)
	