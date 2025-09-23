extends Node2D

const BOARD = preload("uid://cp3h0in414hf7")

func _ready():
	var board = BOARD.instantiate()
	board.size = 8
	board.gap = 0.2	
	add_child(board)
