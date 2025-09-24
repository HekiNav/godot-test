extends Node2D

const BOARD = preload("uid://cp3h0in414hf7")
var config_file_path = "res://levels.json"
const gap = 0.2
func _ready():
	var json = get_json_file_content(config_file_path)
	var board = BOARD.instantiate()
	board.size = json.levels[0].size
	board.data = json.levels[0].data
	add_child(board)
	
func get_json_file_content(filePath):
	var file = FileAccess.open(filePath, FileAccess.READ)
	var content = file.get_as_text()
	return JSON.parse_string(content)
