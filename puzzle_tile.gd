extends Area2D
var data = {}

var mouse_over = false
var powered = false
var can_draw = true
var source = false


func size():
	return %CollisionShape2D.shape.extents
func has_point(point):
	return %CollisionShape2D.shape.get_rect().has_point(to_local(point))
	
func set_data(new_data):
	data = new_data
func _physics_process(_delta: float) -> void:
	if data && data.type == "terminal":
		if powered:
			%Sprite.play("powered")
		else:
			%Sprite.play("unpowered")
func _ready():
	if data.has("id"):
		%IdLabel.append_text(data.id)
	if data.has("type"):
		match data.type:
			"terminal":
				if data.direction == "output":
					%Sprite.play("powered")
					powered = true
					source = true
				else:
					%Sprite.play("unpowered")
					powered = false
					
				pass
			"gap":
				%Sprite.play("none")
				can_draw = false
				pass
			_:
				%Sprite.play("default")
				pass
	else:
		%Sprite.play("default")
func spread_power():
	powered = true
	var overlaps = get_overlapping_areas().filter(func (item):
		return !item.powered
	)
	print(self,"tile", overlaps)
	for connected_item in overlaps:
		connected_item.spread_power()
func _on_sprite_draw() -> void:
	if mouse_over :
		%Sprite.draw_circle(Vector2(0,0),size().x,Color.from_rgba8(255,255,255,100))
