extends Line2D

var spacing
var path
var board_size
var board_scale
var powered

func _ready():
	for point in path:
		var xy = Vector2(floor(point/board_size)+0.5,point % int(board_size)+0.5)
		print(point, xy)
		add_point(xy*spacing)
	width = 32 * board_scale.x
	update()
func update():
	default_color = "#1bb96c" if powered else "#317d58"
