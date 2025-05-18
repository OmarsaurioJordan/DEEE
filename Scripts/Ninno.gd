extends CharacterBody2D

@export var dirInicial: int = 1 # poner -1 o 1 segun hacia donde inicia viendo

# valores constantes
const SPEED: float = 220.0
var gravity: float = ProjectSettings.get_setting("physics/2d/default_gravity")
var animaVel: float = 0

func _ready():
	$Anima.play("idle")
	animaVel = $Anima.speed_scale
	$Imagenes.scale.x = dirInicial

func _physics_process(delta):
	# caer
	if not is_on_floor():
		velocity.y += gravity * delta
	# movimiento solo si el temporizador esta quieto
	if $Viraje.is_stopped():
		$Imagenes/RayFrente.force_raycast_update()
		if $Imagenes/RayFrente.is_colliding():
			$Viraje.start()
		elif $Carrera.is_stopped():
			$Imagenes/RayVista.force_raycast_update()
			if $Imagenes/RayVista.is_colliding():
				if $Imagenes/RayVista.get_collider().name == "Player":
					$Carrera.start()
					$Audio.play()
			elif $Imagenes/RayRevista.is_colliding():
				if $Imagenes/RayRevista.get_collider().name == "Player":
					$Viraje.start()
			velocity.x = move_toward(velocity.x, 0, SPEED)
			$Anima.play("idle")
		else:
			velocity.x = SPEED * $Imagenes.scale.x
			$Anima.play("run")
	# quedarse quieto hasta que temporizador dispare
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		$Anima.play("idle")
	# moverse como tal
	move_and_slide()
	# golpear al player
	if $Imagenes/RayAtaque.is_colliding():
		var player = get_tree().get_first_node_in_group("Player")
		player.Damage()

func _on_viraje_timeout():
	$Imagenes.scale.x *= -1
