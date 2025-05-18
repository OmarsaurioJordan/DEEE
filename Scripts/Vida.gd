extends Area2D

func _ready():
	$Anima.play("idle")

func _on_body_entered(body):
	if body.MasVida():
		$Anima.play("fin")
		call_deferred("VidaOff")
		$Audio.play()

func VidaOff():
	monitoring = false

func _on_anima_animation_finished(anim_name):
	if anim_name == "fin":
		queue_free()
