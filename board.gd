extends Node2D

var size = 1 # width and height of board
var gap = 0 # percent relative to size

const PUZZLE_TILE = preload("uid://cmg4c3ytq5o7g")


func _ready() -> void:
	var tile = PUZZLE_TILE.instantiate()
	var board_scale = %BoardConstraintsShape.shape.extents / (tile.size()*(1+gap)) / size * 2
	var board_origin = %BoardConstraintsShape.global_position - %BoardConstraintsShape.shape.extents
	print(size, gap)
	for x in size:
		for y in size:
			var gap_y = 1+gap if y < size else 1
			var gap_x = 1+gap if x < size else 1
			var new_tile = tile.duplicate()
			new_tile.scale = board_scale * 0.5
			%BoardConstraints.add_child(new_tile)
			new_tile.global_position = board_origin + (new_tile.size() * board_scale * Vector2(x*gap_x+0.5,y*gap_y+0.5))
		
