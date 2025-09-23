extends CharacterBody2D

	
var health = 2

@onready var player = get_node("/root/Game/Player")

func _ready():
	%Slime.play_walk()


func _physics_process(_delta: float):
	var direction = global_position.direction_to(player.global_position)
	velocity = direction * 100
	move_and_slide()
func take_damage():
	const SMOKE_SCENE = preload("res://smoke_explosion/smoke_explosion.tscn")
	
	%Slime.play_hurt()
	health -= 1
	if health <= 0:
		var smoke = SMOKE_SCENE.instantiate()
		add_sibling(smoke)
		smoke.global_position = global_position
		queue_free()
