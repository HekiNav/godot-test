extends Node2D

var size = 1 # width and height of board
var gap = 0 # percent relative to size
var data = {}
var tiles = []

var tiles_in_last_line = []

const PUZZLE_TILE = preload("res://puzzle_tile.tscn")
const SNAKE = preload("res://utils/snake.tscn")


var mouse_down = false

var tile_spacing
var board_scale
var board_origin

func _ready() -> void:
	var tile = PUZZLE_TILE.instantiate()
	board_scale = %BoardConstraintsShape.shape.extents / (tile.size()*(1+gap)) / size * 2
	board_origin = %BoardConstraintsShape.global_position - %BoardConstraintsShape.shape.extents
	tile_spacing = board_scale * (tile.size() * Vector2(1+gap,1+gap))
	for x in size:
		var rowData = data[str(int(x))] if data.has(str(int(x))) else {}
		for y in size:
			var cellData = rowData[str(int(y))] if rowData.has(str(int(y))) else {}
			var gap_y = 1+gap if y < size else 1.0
			var gap_x = 1+gap if x < size else 1.0
			var new_tile = tile.duplicate()
			new_tile.set_data(cellData)
			new_tile.scale = board_scale * 0.5
			%BoardConstraints.add_child(new_tile)
			new_tile.global_position = board_origin + (new_tile.size() * board_scale * Vector2(x*gap_x+0.5,y*gap_y+0.5))
			tiles.append(new_tile)


func _on_board_constraints_input_event(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
	var i = tiles.find_custom(
		func (tile):
			return tile.has_point(event.position)
	)
	if event.is_action("draw_trace"):
		if event.pressed:
			tiles_in_last_line.append(i)
		else:
			createSnake(tiles_in_last_line)
			tiles_in_last_line.clear()
	elif event.is_action("erase_trace"):
		pass
	else:
		if event.pressure > 0:
			if (i >= 0 && tiles_in_last_line.back() != i):
				tiles_in_last_line.append(i)
func createSnake(snake_tiles: Array):
	var first_tile = tiles[snake_tiles[0]]
	var new_snake = SNAKE.instantiate()
	new_snake.spacing = tile_spacing
	new_snake.path = snake_tiles
	new_snake.board_size = size
	new_snake.board_scale = board_scale
	new_snake.global_position = board_origin
	new_snake.powered = first_tile.powered
	add_child(new_snake)
