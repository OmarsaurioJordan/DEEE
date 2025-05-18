extends CharacterBody2D

# valores constantes
const SPEED: float = 150.0
var gravity: float = ProjectSettings.get_setting("physics/2d/default_gravity")

func _ready():
	$Anima.play("idle")

func _physics_process(delta):
	# caer
	if not is_on_floor():
		velocity.y += gravity * delta
	# ver donde esta el player
	var direccion = 0
	if $RayVistaL.is_colliding():
		if $RayVistaL.get_collider().name == "Player":
			direccion = -1
	if $RayVistaR.is_colliding():
		if $RayVistaR.get_collider().name == "Player":
			direccion = 1
	# quedarse quieto
	if direccion == 0:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		$Anima.play("idle")
	# tratar de perseguir player
	else:
		# verificar si hay suelo
		$Imagenes.scale.x = direccion
		$Imagenes/RayCaida.force_raycast_update()
		# correr
		if $Imagenes/RayCaida.is_colliding():
			velocity.x = SPEED * $Imagenes.scale.x
			$Anima.play("run")
			if not $Audio.playing:
				$Audio.play()
		# quedarse quieto
		else:
			velocity.x = move_toward(velocity.x, 0, SPEED)
			$Anima.play("idle")
	# moverse como tal
	move_and_slide()

func _on_ataque_body_entered(body):
	body.Damage()
