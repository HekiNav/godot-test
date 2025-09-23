extends CharacterBody2D

signal health_depleted

var health = 100.0

const DAMAGE_RATE = 10.0

func _physics_process(delta: float):
	var direction = Input.get_vector("move_left","move_right","move_up","move_down")
	velocity = direction * 400
	move_and_slide()
	var happyBoo = %HappyBoo
	if velocity.length() > 0:
		happyBoo.play_walk_animation()
	else:
		happyBoo.play_idle_animation()
	var overlapping_mobs = %HurtBox.get_overlapping_bodies()
	if overlapping_mobs.size() > 0:
		health -= overlapping_mobs.size() * delta * DAMAGE_RATE
		%ProgressBar.value = health
		if health <= 0.0:
			health_depleted.emit()
