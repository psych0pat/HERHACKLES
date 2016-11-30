extends Area2D

export(String) var next_scene

func _ready():
	pass
	
func _on_exit_body_enter(body):
	if body.get_name() == 'player':
		get_tree().change_scene_to(global.levels[next_scene].scene)
		global.current_level = next_scene
		
		