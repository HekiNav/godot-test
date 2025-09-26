extends Node2D

var sprite_unpowered
var sprite_powered
var tile_spacing
var width
var height
var xoffset
var yoffset
var tiles
var offset

var location

var board

var powered = null
var tile_indexes = []
func _ready() -> void:
	%Sprite.sprite_frames.add_frame("powered",path_to_texture(sprite_powered))
	%Sprite.sprite_frames.add_frame("unpowered",path_to_texture(sprite_unpowered))
	%CollisionShape2D.shape.size = Vector2(width,height) * tile_spacing
	%MouseCollisionShape.shape.radius = min(width,height) * tile_spacing.x * 0.5
	set_tiles()
func path_to_texture(path):
	var texture = load(path)
	return texture
func has_mouse(mouse_position):
	return %MouseCollisionShape.shape.get_rect().has_point(to_local(mouse_position))
func _physics_process(_delta: float) -> void:
	if board.tiles.size() == 0:
		return
	if tile_indexes.size() && tile_indexes.all(func(t):
		#print(board.tiles[t].fulfilled())
		return board.tiles[t].fulfilled()
	):
		%Sprite.play("powered")
	else: 
		%Sprite.play("unpowered")
func clear_tiles():
	for i in tile_indexes:
		board.set_tile({},i)
	tile_indexes = []
func set_tiles():
	for x in tiles.size():
		for y in tiles[x].size():
			var i = (location.x + y) * board.size + location.y + x
			var data = tiles[x][y]
			tile_indexes.append(i)
			data.set("black",true)
			board.set_tile(data, i)
