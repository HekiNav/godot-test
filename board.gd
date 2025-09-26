extends Node2D

var size = 1 # width and height of board
var gap = 0.1 # percent relative to size
var data = {}
var component_data = []
var component_library = []
var tiles = []
var snakes = []
var components = []

var temp_snake

signal win

const PUZZLE_TILE = preload("res://puzzle_tile.tscn")
const SNAKE = preload("res://utils/snake.tscn")
const COMPONENT = preload("res://component.tscn")


var mouse_down = false

var tile_spacing
var tile_size
var board_scale
var board_origin

func _ready() -> void:
	reload()

func reload():
	for tile in tiles:
		tile.queue_free()
	for snake in snakes:
		if snake:
			snake.queue_free()
	tiles = []
	snakes = []
	components = []
	# GENERATING COMPONENTS
	
	var component = COMPONENT.instantiate()
	
	var tile = PUZZLE_TILE.instantiate()
	board_scale = %BoardConstraintsShape.shape.extents / (tile.size()*(1+gap)) / size * 2
	board_origin = %BoardConstraintsShape.global_position - %BoardConstraintsShape.shape.extents
	tile_spacing = board_scale * (tile.size() * Vector2(1+gap,1+gap))
	tile_size = tile.size() * board_scale
	
	if component_data:
		for com in component_data:
			var lib_ref = component_library.get(component_library.find_custom(func (item):
				return item.id == com.id
			))
			var new_component = component.duplicate()
			new_component.sprite_unpowered = lib_ref.unpowered
			new_component.sprite_powered = lib_ref.powered
			new_component.width = lib_ref.width
			new_component.height = lib_ref.height
			new_component.xoffset = lib_ref.xoffset
			new_component.yoffset = lib_ref.yoffset
			new_component.tiles = lib_ref.tiles
			var x = 1 + (lib_ref.width - 1) * gap
			new_component.scale = board_scale * 0.5 * x
			print(x)
			new_component.global_position = board_origin + tile_spacing * Vector2(0+lib_ref.xoffset,0+lib_ref.yoffset)
			
			add_child(new_component)
			components.append(new_component)
	
	
	for x in size:
		var rowData = data[str(int(x))] if data.has(str(int(x))) else {}
		for y in size:
			var cellData = rowData[str(int(y))] if rowData.has(str(int(y))) else {}
			var gap_y = 1.0+gap if y < size else 1.0
			var gap_x = 1.0+gap if x < size else 1.0
			var new_tile = tile.duplicate()
			new_tile.set_data(cellData)
			new_tile.scale = board_scale * 0.5
			%BoardConstraints.add_child(new_tile)
			new_tile.global_position = board_origin + (new_tile.size() * board_scale * Vector2(x*gap_x+0.5,y*gap_y+0.5))
			tiles.append(new_tile)
func _on_board_constraints_input_event(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
	var i = tiles.find_custom(
		func (tile):
			var val = tile.has_point(event.position) if tile  else false
			return val
	)
	if event.is_action("draw_trace"):
		if event.pressed:
			if isFree(i, null):
				createSnake([i])
		elif temp_snake:
			snakes.append(temp_snake)
			temp_snake = null
			checkConnections()
	elif event.is_action("erase_trace"):
		if event.pressed:
			pass
		else:
			checkConnections()
		pass
	else:
		if event.button_mask == 1:
			var last_tile = temp_snake.path.back() if temp_snake else -1
			var diff = abs(last_tile-i) if last_tile >= 0 else 0
			if (i >= 0 && 
				last_tile != i && 
				(diff == 1 || diff == size) && # stops diagonals
				isFree(i, temp_snake.powered)
			):
				temp_snake.append(i)
		elif event.button_mask == 2:
			if i > 0:
				for snake in snakes:
					if snake:
						var new_path = snake.remove(i)
						if new_path:
							createSnake(new_path)
		if event.button_mask == 0 && temp_snake:
			snakes.append(temp_snake)
			temp_snake = null
func deleteTempSnake():
	temp_snake.queue_free()
func isFree(tile, current_power):
	return (
		tiles[tile].can_draw_power(current_power) && 
		((
			tiles[tile].powered == current_power ||
			tiles[tile].powered == null ||
			current_power == null
		) ||
		(
			snakes.find_custom(func (snake):
			return (
				snake.path.has(tile) && 
				snake.powered != current_power && 
				snake.powered != null
			)
			)
		) < 0))

func checkConnections():
	for tile in tiles:
		tile.powered = null
	for snake in snakes:
		if snake:
			snake.powered = null
	for tile in tiles:
		if tile.source:
			tile.spread_power(tile.data.id)
	checkWin()

func checkWin():
	var result = tiles.all(func (tile):
		return tile.fulfilled()
	)
	if result:
		win.emit()

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
