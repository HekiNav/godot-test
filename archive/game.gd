extends Node2D

func _ready() -> void:
	var i = 0;
	while i <= 5:
		spawn_mob()
		i += 1

func spawn_mob():
	var new_mob = preload("res://enemy/mob.tscn").instantiate()
	%PathFollow2D.progress_ratio = randf()
	new_mob.global_position = %PathFollow2D.global_position
	add_child(new_mob)
	


func _on_timer_timeout() -> void:
	spawn_mob() # Replace with function body.
