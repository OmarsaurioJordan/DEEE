extends Area2D

func _ready():
	$Anima.play("idle")

func _on_body_entered(body):
	body.Checkpoint(position)
	match name:
		"Checkpoint1":
			body.DialogoA()
		"Checkpoint3":
			body.DialogoB()
		"Checkpoint2":
			body.DialogoC()
		"Checkpoint4":
			body.DialogoD()
	$Anima.play("fin")
	call_deferred("CheckOff")
	$Audio.play()

func CheckOff():
	monitoring = false

func _on_anima_animation_finished(anim_name):
	if anim_name == "fin":
		queue_free()
