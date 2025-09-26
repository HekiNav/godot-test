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
	%CollisionShape2D.shape.size = Vector2(width,height)
func path_to_texture(path):
	var texture = load(path)
	return texture
func has_mouse(mouse_position):
	print(%CollisionShape2D.shape,position)
	return %CollisionShape2D.shape.get_rect().has_point(mouse_position)
