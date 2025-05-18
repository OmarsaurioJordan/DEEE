extends CharacterBody2D

# constantes
const explosion = preload("res://Scenes/Explosion.tscn")
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

# variables que cambian durante el juego
var debeCaer = false

func _physics_process(delta):
	if not debeCaer:
		if $RayCaer.is_colliding():
			if $RayCaer.get_collider().name == "Player":
				debeCaer = true
				$Img.frame = randi_range(1, 7)
				$Audio.play()
		return null
	# caer
	rotation += 30.0 * delta
	if not is_on_floor():
		velocity.y += gravity * delta * 0.25
		move_and_slide()
	# explotar
	else:
		var aux = explosion.instantiate()
		get_parent().add_child(aux)
		aux.position = position
		queue_free()

func _on_area_body_entered(body):
	body.Damage()
