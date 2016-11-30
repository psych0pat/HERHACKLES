extends Node2D

var bounds
var background_light

func _ready():
	var tiles = get_node('tiles')
	var background = get_node('background')
	var foreground = get_node('foreground')
	bounds = calculate_tilemap_size(tiles)
	
	background.set_z_as_relative(false)
	background.set_z(-10)
	foreground.set_z_as_relative(false)
	foreground.set_z(10)
	
	foreground.set_light_mask(2)
	tiles.set_light_mask(2)
	background.set_light_mask(4)
	
	background.set_collision_mask(4)
	background.set_collision_layer(4)
	
	
# https://godotengine.org/qa/7450/how-do-i-get-tilemaps-size-height-and-width-with-script
func calculate_tilemap_size(tilemap):
    # Get list of all positions where there is a tile
    var used_cells = tilemap.get_used_cells()

    # If there are none, return null result
    if used_cells.size() == 0:
        return {x=0, y=0, width=0, height=0}

    # Take first cell as reference
    var min_x = used_cells[0].x
    var min_y = used_cells[0].y
    var max_x = min_x
    var max_y = min_y

    # Find bounds
    for i in range(1, used_cells.size()):

        var pos = used_cells[i]

        if pos.x < min_x:
            min_x = pos.x
        elif pos.x > max_x:
            max_x = pos.x

        if pos.y < min_y:
            min_y = pos.y
        elif pos.y > max_y:
            max_y = pos.y

    # Return resulting bounds
    return {
        x = min_x * tilemap.get_cell_size().x ,
        y = min_y * tilemap.get_cell_size().y,
        width = (max_x - min_x + 1) * tilemap.get_cell_size().x,
        height = (max_y - min_y + 1) * tilemap.get_cell_size().y
    }
