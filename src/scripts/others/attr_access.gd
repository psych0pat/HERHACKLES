extends Node

static func get_attributes(entity):
	var name = entity.get_name().split(' ')[0]
	return {
		'turn': build_attributes('turn', name),
		'get': build_attributes('get', name),
		'set': build_attributes('set', name)
	}

static func build_attributes(type, name):
	if !name in global.levels[global.current_level].elements:
		return []
		
	if !type in global.levels[global.current_level].elements[name]:
		return []
		
	var attributes = []
	for attr in global.levels[global.current_level].elements[name][type]:
		attributes.append(attr)
		
	return attributes