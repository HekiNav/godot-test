extends Node2D

var sprite_unpowered
var sprite_powered
var width
var height
var xoffset
var yoffset
var tiles

var powered = null

func _ready() -> void:
	%Sprite.sprite_frames.add_frame("powered",path_to_texture(sprite_powered))
	%Sprite.sprite_frames.add_frame("unpowered",path_to_texture(sprite_unpowered))
func path_to_texture(path):
	var texture = load(path)
	return texture
