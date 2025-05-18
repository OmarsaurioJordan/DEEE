extends Area2D

func _ready():
	$Anima.play("RESET")
	$Iniciador.start(randf_range(1, 4))

func _on_anima_animation_finished(anim_name):
	$Coli.disabled = true
	match anim_name:
		"low":
			$Anima.play("open")
		"full":
			$Anima.play("close")
		"close":
			$Anima.play("low")
		"open":
			$Anima.play("full")
			$Coli.disabled = false
			$Audio.play()

func _on_body_entered(body):
	body.Damage()

func _on_iniciador_timeout():
	$Anima.play("low")
