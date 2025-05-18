extends CharacterBody2D

# constantes
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

func _ready():
	$Anima.play("idle")

func _physics_process(delta):
	# ver hacia el jugador
	var player = get_tree().get_first_node_in_group("Player")
	if player.position.x > position.x:
		$Imagenes.scale.x = 1
	else:
		$Imagenes.scale.x = -1
	# caer
	if not is_on_floor():
		velocity.y += gravity * delta
	move_and_slide()

func _on_area_body_entered(_body):
	$Imagenes/Area.queue_free()
	var player = get_tree().get_first_node_in_group("Player")
	player.DialogoFinal()
