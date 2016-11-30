extends Node2D

export(int) var damage = 10
var attributes
var hacking_effect
var last_hacker
var scale
export(bool) var on = true

func _init():
	attributes = global.Attributes.new(self)

func destroy():
	self.queue_free()
	
func outside_map(treshold = Vector2(50, 50)):
	var tilemap = global.active_scene.get_node('tilemap')
	return self.get_pos().x < -treshold.x or \
		self.get_pos().x > tilemap.bounds.width + treshold.x or \
		self.get_pos().y < -tilemap.bounds.y - treshold.y or \
		self.get_pos().y > tilemap.bounds.y + tilemap.bounds.height + treshold.y

