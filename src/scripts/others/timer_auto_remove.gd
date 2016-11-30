extends Timer

func _ready():
	connect("timeout", get_parent(), "queue_free")
	