extends GPUParticles2D

func _ready():
	emitting = true
	$Audio.play()

func _on_finished():
	queue_free()

func _on_area_body_entered(body):
	$Area.queue_free()
	$Fin.stop()
	body.Damage()

func _on_fin_timeout():
	$Area.queue_free()
