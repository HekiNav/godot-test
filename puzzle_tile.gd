extends Area2D
var data = {}

var powered = null
var can_draw = true
var source = false


func size():
	return %CollisionShape2D.shape.extents
func has_point(point):
	return %CollisionShape2D.shape.get_rect().has_point(to_local(point))
	
func set_data(new_data):
	data = new_data
func _physics_process(_delta: float) -> void:
	update()
func update():
	if data.has("id"):
		if data.has("black"):
			%IdLabelBlack.text = data.id
			%IdLabel.text = ""
		else:
			%IdLabel.text = data.id
			%IdLabelBlack.text = ""
	else:
		%IdLabelBlack.text = ""
		%IdLabel.text = ""
	if data.has("type"):
		match data.type:
			"terminal":
				if data.direction == "output":
					source = true
					powered = data.id
				if powered == data.id || source:
					%Sprite.play("powered")
				else:
					%Sprite.play("unpowered")
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
func spread_power(id):
	powered = id
	var overlaps = get_overlapping_areas().filter(func (item):
		return !item.powered
	)
	print("tile",self, overlaps, powered)
	for connected_item in overlaps:
		connected_item.spread_power(id)
func can_draw_power(power):
	if data.has("type") && data.type == "terminal" && data.direction == "input":
		return can_draw && (data.id == power || power == null)
	return can_draw
func fulfilled():
	if data.has("type"):
		match data.type:
			"terminal":
				return data.direction == "output" || powered == data.id
			_:
				return true
	else:
		return true
