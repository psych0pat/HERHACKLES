extends Panel

export(String) var text

func _ready():
	get_node('label').set_text(text)