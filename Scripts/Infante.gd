extends CharacterBody2D

# valores constantes
const JUMP_VELOCITY: float = 300.0
const SPEED: float = 100.0
var gravity: float = ProjectSettings.get_setting("physics/2d/default_gravity")
var tipo: String = str(randi_range(0, 1))
var animaVel: float = 0

func _ready():
	animaVel = $Anima.speed_scale
	$Anima.play("down" + tipo)
	$Anima.speed_scale = 0
	$Iniciador.start(randf_range(1, 4))
	if randf() < 0.5:
		$Imagenes.scale.x *= -1

func _physics_process(delta):
	# caer
	if not is_on_floor():
		velocity.y += gravity * delta
		velocity.x = SPEED * $Imagenes.scale.x
	else:
		velocity.x = 0
	# movimiento solo si el temporizador esta quieto
	if $Imagenes/RayFrente.is_colliding() or not $Imagenes/RayCaida.is_colliding():
		$Imagenes.scale.x *= -1
	# moverse como tal
	move_and_slide()

func _on_anima_animation_finished(anim_name):
	if anim_name == "up0" or anim_name == "up1":
		$Anima.play("down" + tipo)
	elif is_on_floor():
		$Anima.play("up" + tipo)
		velocity.y = -JUMP_VELOCITY
		$Audio.play()
	else:
		$Anima.play("down" + tipo)

func _on_iniciador_timeout():
	$Anima.speed_scale = animaVel

func _on_ataque_body_entered(body):
	if velocity.y < 0:
		body.Damage()
