extends Area2D

var spacing
var path = []
var board_size
var tile_size
var board_scale
var powered = null
var is_snake = true

func _ready():
	%Line.width = 32 * board_scale.x
	update()
func _physics_process(_delta: float) -> void:
	%Line.default_color = "#1bb96c" if powered else "#317d58"
func update():
	if path.size() == 0:
		queue_free()
	%Line.clear_points()
	for child in get_children():
		if is_instance_of(child, CollisionShape2D):
			child.free()
	
	for index in path.size():
		var point = path[index]
		var prev_point = path[index-1] if index > 0 else null
		var xy = Vector2(floor(point/board_size),point % int(board_size))
		var point_xy = xy*spacing+Vector2(0.5,0.5)*tile_size
		%Line.add_point(point_xy)
		if prev_point:
			var prev_xy = Vector2(floor(prev_point/board_size),prev_point % int(board_size))
			var prev_point_xy = prev_xy*spacing+Vector2(0.5,0.5)*tile_size
			var segment = CollisionShape2D.new()
			segment.shape = SegmentShape2D.new()
			segment.shape.a = prev_point_xy
			segment.shape.b = point_xy
			segment.debug_color = Color.RED
			add_child(segment)
func _draw() -> void:
	if path.size() == 1:
		draw_circle(%Line.points[0],%Line.width*0.5,%Line.default_color)
func append(point):
	path.append(point)
	update()
func remove(point):
	var i = path.find(point)
	if i == 0 || i == path.size():
		path.pop_at(i)
		update()
	elif i >= 0:
		var new_path = path.slice(i+1,path.size())
		path = path.slice(0,i)
		update()
		return new_path
		
func spread_power(id):
	powered = id
	var overlaps = get_overlapping_areas().filter(func (item):
		return !item.powered
	)
	print("snake",self,  overlaps)
	for connected_item in overlaps:
		connected_item.spread_power(id)
