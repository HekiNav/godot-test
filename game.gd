extends Node2D

const BOARD = preload("res://board.tscn")
const WIN_SCREEN = preload("res://win_screen.tscn")
var config_file_path = "res://levels.json"
const gap = 0.2
var level_index = 0
var json
var board
func _ready():
	json = get_json_file_content(config_file_path)
	board = BOARD.instantiate()
	board.size = json.levels[level_index].size
	board.data = json.levels[level_index].data
	board.component_library = json.components
	board.component_data = json.levels[level_index].components if json.levels[level_index].has("components") else []
	add_child(board)
	board.connect("win",func():
		%Timer.start()
	)

func get_json_file_content(filePath):
	var file = FileAccess.open(filePath, FileAccess.READ)
	var content = file.get_as_text()
	return JSON.parse_string(content)


func _on_timer_timeout() -> void:
	level_index += 1
	if level_index < json.levels.size():
		board.size = json.levels[level_index].size
		board.data = json.levels[level_index].data
		board.component_data = json.levels[level_index].components if json.levels[level_index].has("components") else []
		board.reload()
	else:
		board.size = 0
		board.data = {}
		board.reload()
		var win_screen = WIN_SCREEN.instantiate()
		add_child(win_screen)
