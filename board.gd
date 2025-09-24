extends Node2D

var size = 1 # width and height of board
var gap = 0.1 # percent relative to size
var data = {}
var tiles = []
var snakes = []

var temp_snake

const PUZZLE_TILE = preload("res://puzzle_tile.tscn")
const SNAKE = preload("res://utils/snake.tscn")


var mouse_down = false

var tile_spacing
var tile_size
var board_scale
var board_origin

func _ready() -> void:
	var tile = PUZZLE_TILE.instantiate()
	board_scale = %BoardConstraintsShape.shape.extents / (tile.size()*(1+gap)) / size * 2
	board_origin = %BoardConstraintsShape.global_position - %BoardConstraintsShape.shape.extents
	tile_spacing = board_scale * (tile.size() * Vector2(1+gap,1+gap))
	tile_size = tile.size() * board_scale
	for x in size:
		var rowData = data[str(int(x))] if data.has(str(int(x))) else {}
		for y in size:
			var cellData = rowData[str(int(y))] if rowData.has(str(int(y))) else {}
			var gap_y = 1+gap if y < size else 1
			var gap_x = 1+gap if x < size else 1
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
			if isFree(i):
				createSnake([i])
		elif temp_snake:
			snakes.append(temp_snake)
			temp_snake = null
			checkConnections()
	elif event.is_action("erase_trace"):
		pass
	else:
		var last_tile = temp_snake.path.back() if temp_snake else -1
		var diff = abs(last_tile-i) if last_tile >= 0 else 0
		if event.pressure > 0:
			if (i >= 0 && 
				last_tile != i && 
				(diff == 1 || diff == size) && # stops diagonals
				isFree(i)
			):
				temp_snake.append(i)
func deleteTempSnake():
	temp_snake.queue_free()
func isFree(tile):
	return tiles[tile].can_draw && (snakes.find_custom(func (snake):
		return snake.path.slice(1,snake.path.size()-1).has(tile)
		)) < 0

func checkConnections():
	for tile in tiles:
		tile.powered = false
	for snake in snakes:
		snake.powered = false
	for tile in tiles:
		if tile.source:
			tile.spread_power()

func createSnake(snake_tiles: Array):
	if temp_snake:
		deleteTempSnake()
	var first_tile = tiles[snake_tiles[0]]
	temp_snake = SNAKE.instantiate()
	temp_snake.spacing = tile_spacing
	temp_snake.tile_size = tile_size
	temp_snake.path = snake_tiles
	temp_snake.board_size = size
	temp_snake.board_scale = board_scale
	temp_snake.global_position = board_origin
	temp_snake.powered = first_tile.powered
	add_child(temp_snake)
