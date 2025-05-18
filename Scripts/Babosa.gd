extends CharacterBody2D

# valores constantes
const SPEED: float = 130.0
var gravity: float = ProjectSettings.get_setting("physics/2d/default_gravity")
var animaVel: float = 0

func _ready():
	$Anima.play("run")
	animaVel = $Anima.speed_scale
	if randf() < 0.5:
		$Imagenes.scale.x *= -1

func _physics_process(delta):
	# caer
	if not is_on_floor():
		velocity.y += gravity * delta
	# movimiento solo si el temporizador esta quieto
	if $Viraje.is_stopped():
		$Imagenes/RayFrente.force_raycast_update()
		$Imagenes/RayCaida.force_raycast_update()
		if $Imagenes/RayFrente.is_colliding() or not $Imagenes/RayCaida.is_colliding():
			$Viraje.start()
		else:
			velocity.x = SPEED * $Imagenes.scale.x
			$Anima.speed_scale = animaVel
			SonidoPasos(true)
	# quedarse quieto hasta que temporizador dispare
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		$Anima.speed_scale = 0
		SonidoPasos(false)
	# moverse como tal
	move_and_slide()
	# golpear al player
	if $Imagenes/RayAtaque.is_colliding():
		var player = get_tree().get_first_node_in_group("Player")
		player.Damage()

func _on_viraje_timeout():
	$Imagenes.scale.x *= -1

func SonidoPasos(sonar: bool):
	if sonar:
		if not $Audio.playing:
			$Audio.play()
	else:
		if $Audio.playing:
			$Audio.stop()
