extends CharacterBody2D

# valores constantes
const JUMP_VELOCITY = 700.0
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

func _ready():
	$Anima.play("run")
	$Salto.start(randf_range(1, 4))

func _physics_process(delta):
	# caida
	if not is_on_floor():
		velocity.y += gravity * delta
	move_and_slide()
	# salto
	if is_on_floor() and $Salto.is_stopped():
		$Salto.start(randf_range(1, 3))
		$Audio.play()

func _on_salto_timeout():
	velocity.y = -JUMP_VELOCITY

func _on_golpeador_body_entered(body):
	body.Damage()
