extends CharacterBody2D

# constantes
const proyectil = preload("res://Scenes/Proyectil.tscn")
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

func _ready():
	$Anima.play("idle")

func _physics_process(delta):
	# ver hacia el jugador
	if $Anima.current_animation != "shot":
		var player = get_tree().get_first_node_in_group("Player")
		if player.position.x > position.x:
			$Imagenes.scale.x = 1
		else:
			$Imagenes.scale.x = -1
	# caer
	if not is_on_floor():
		velocity.y += gravity * delta
	move_and_slide()
	# ver si ve al jugador y debe disparar
	if $Anima.current_animation == "idle":
		if $Imagenes/RayTiro.is_colliding():
			if $Imagenes/RayTiro.get_collider().name == "Player":
				$Anima.play("shot")

func _on_anima_animation_finished(anim_name):
	match anim_name:
		"shot":
			$Anima.play("postshot")
			var player = get_tree().get_first_node_in_group("Player")
			if player.puedeMover:
				var aux = proyectil.instantiate()
				get_parent().add_child(aux)
				aux.position = $Imagenes/Foco.global_position
				aux.velocidad *= $Imagenes.scale.x
				$Audio.play()
		"postshot":
			$Anima.play("idle")
