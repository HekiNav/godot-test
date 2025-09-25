extends Node2D

const GAME = preload("res://game.tscn")


func _on_play_pressed() -> void:
	var game = GAME.instantiate()
	for child in get_children():
		child.queue_free()
	add_child(game)
