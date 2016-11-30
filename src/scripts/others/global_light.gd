extends BackBufferCopy

export(Color) var modulate = Color(1, 1, 1, 1)

func _ready():
	get_node('canvas_layer').get_node('modulate').set_color(modulate)
	set_process(true)

func _process(delta):
	get_node('canvas_layer').get_node('modulate').set_color(modulate)
