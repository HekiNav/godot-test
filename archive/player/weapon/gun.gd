extends Area2D

signal shot

func _physics_process(_delta: float) -> void:
	var enemies_in_range = get_overlapping_bodies()
	if enemies_in_range.size() > 0:
		var target = enemies_in_range[0]
		look_at(target.global_position)

func shoot():
	shot.emit()
	const BULLET = preload("res://player/weapon/projectile.tscn")
	var projectile = BULLET.instantiate()
	projectile.global_position = %ShootingPoint.global_position
	projectile.global_rotation = %ShootingPoint.global_rotation
	%ShootingPoint.add_child(projectile)


func _on_timer_timeout() -> void:
	if get_overlapping_bodies().size() > 0:
		shoot()
