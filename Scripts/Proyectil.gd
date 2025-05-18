extends Area2D

# var y no const, porque sera cambiada por disparador
var velocidad: float = 230.0

func _ready():
	$Img.rotation = randf() * 2.0 * PI

func _process(delta):
	if $RayMuro.is_colliding():
		queue_free()
	else:
		position.x += velocidad * delta

func _on_body_entered(body):
	if body.name == "Player":
		body.Damage()
	queue_free()

func _on_fin_timeout():
	queue_free()
