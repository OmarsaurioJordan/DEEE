extends CharacterBody2D

# valores constantes
const CAIDA: float = 580.0 # si velocidad vertical supera este numero, muere
const SPEED: float = 200.0
const JUMP_VELOCITY: float = 440.0
var gravity: float = ProjectSettings.get_setting("physics/2d/default_gravity")

# valores que cambiaran durante el juego
var posInicial: Vector2 = Vector2() # checkpoint para reaparecer
var puedeMover = true # para quedarse quieto si hay dialogos

# puntajes: intentos, damage
var puntos = [0, 0]

func _enter_tree():
	posInicial = position

func _ready():
	call_deferred("Respawn")
	call_deferred("DialogoInicial")

func _physics_process(delta):
	# al no poder moverse, verificar si el dialogo cerro
	if not puedeMover:
		Caer(delta)
		move_and_slide()
		var gui = get_tree().get_first_node_in_group("GUI")
		if gui.get_node("Chat").IsFree():
			puedeMover = true
		return null
	# confirmar si ha muerto, verificando animacion actual
	if $Anima.get_current_animation() == "dead":
		Caer(delta)
		move_and_slide()
		if $Revivir.is_stopped() and Input.is_action_just_pressed("com_up"):
			Respawn()
		return null
	# acciones en suelo
	if is_on_floor():
		# saltar
		if Input.is_action_just_pressed("com_up"):
			velocity.y = -JUMP_VELOCITY
			$Anima.play("salto")
		elif $Anima.get_current_animation() == "salto":
			$Anima.play("idle")
	# acciones en caida
	else:
		if Caer(delta):
			return null
	# movimiento horizontal
	var direction = Input.get_axis("com_left", "com_right")
	if direction != 0:
		velocity.x = direction * SPEED
		$Imagenes.scale.x = direction
		if $Anima.get_current_animation() != "salto":
			$Anima.play("run")
			$Anima.speed_scale = 6
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		if $Anima.get_current_animation() != "salto":
			$Anima.play("idle")
			$Anima.speed_scale = 3
	# moverse como tal
	move_and_slide()

func Caer(delta):
	velocity.y += gravity * delta
	if velocity.y > CAIDA:
		return Damage()
	return false

func Damage():
	if not puedeMover:
		return false
	if $Anima.get_current_animation() == "dead":
		return false
	if $Invisible.get_current_animation() == "RESET":
		puntos[1] += 1
		Puntaje()
		var gui = get_tree().get_first_node_in_group("GUI")
		if gui.get_node("Vidas").frame == 0:
			gui.get_node("Vidas").frame = 1
			$Invisible.play("damage")
			$AudioDamage.play()
			$AudioMuerte.stop()
		else:
			gui.get_node("Vidas").frame = 2
			Muerte()
			return true
	return false

func Muerte():
	$Anima.play("dead")
	velocity.x = 0
	$Revivir.start()
	$AudioDamage.stop()
	$AudioMuerte.play()

func MasVida():
	var gui = get_tree().get_first_node_in_group("GUI")
	if gui.get_node("Vidas").frame == 1:
		gui.get_node("Vidas").frame = 0
		$Invisible.play("respawn")
		return true
	elif gui.get_node("Vidas").frame == 2:
		gui.get_node("Vidas").frame = 1
		$Invisible.play("respawn")
		$Anima.play("idle")
		$Revivir.stop()
		return true
	return false

func Checkpoint(pos):
	posInicial = pos
	# revivir si es necesario
	var gui = get_tree().get_first_node_in_group("GUI")
	if gui.get_node("Vidas").frame == 2:
		MasVida()

func Respawn():
	# volver a un punto dado, usar posInicial como checkpoint
	position = posInicial
	var gui = get_tree().get_first_node_in_group("GUI")
	gui.get_node("Vidas").frame = 0
	$Invisible.play("respawn")
	$Anima.play("idle")
	get_parent().Respawn()
	puntos[0] += 1
	Puntaje()

func Puntaje():
	var gui = get_tree().get_first_node_in_group("GUI")
	gui.get_node("Puntos").text = str(puntos[0]) + " :Intentos\n" +\
		str(puntos[1]) + " :Daño"

func DialogoInicial():
	var gui = get_tree().get_first_node_in_group("GUI")
	var t: Array[String] = [
		"Ahhh olor a alma nueva, bienvenida al infierno señora Ginna, espere acá hasta que uno de nuestros lacayos le asigne un castigo...",
		"¡Qué! ¡estoy muerta! iba en... el avión... ¡no puede ser! ¿y David? ¿dónde está mi esposo? y mi amiga... cielos ella que soñaba ser una buena chef...",
		"Debería preocuparse por su alma, no puedo contestarle esas preguntas, al menos no acá, ya debo desvanecerme...",
		"David... debo encontrarlo, seguro está acá igual que yo, debo... decirle algo importante, y... debemos salir de aquí, de este mal sueño ¡estamos vivos!"
	]
	var b: Array[bool] = [
		false,
		true,
		false,
		true
	]
	gui.get_node("Chat").AddChat(t, b)
	gui.get_node("Chat").Avance()
	Frenar()
	# hacer aparecer espectro
	get_tree().get_first_node_in_group("Espectro").visible = true
	$AudioInicio.play()

func DialogoA():
	var gui = get_tree().get_first_node_in_group("GUI")
	var t: Array[String] = [
		"O quizá si morimos después de todo, este olor a azufre, esos fetos, este calor, ¡David! ¿dónde estás?"
	]
	var b: Array[bool] = [
		true
	]
	gui.get_node("Chat").AddChat(t, b)
	gui.get_node("Chat").Avance()
	Frenar()

func DialogoB():
	var gui = get_tree().get_first_node_in_group("GUI")
	var t: Array[String] = [
		"Tres semanas, solo tres semanas de embarazo... solo eso y David no lo supo, quería vivir una vida larga, pero no le dije, temía..."
	]
	var b: Array[bool] = [
		true
	]
	gui.get_node("Chat").AddChat(t, b)
	gui.get_node("Chat").Avance()
	Frenar()

func DialogoC():
	var gui = get_tree().get_first_node_in_group("GUI")
	var t: Array[String] = [
		"Esa cosa... ¿qué diablos era esa cosa? putrefacta, desnuda y llena de agonía ¿por qué no veo más personas normales? será ese nuestro destino..."
	]
	var b: Array[bool] = [
		true
	]
	gui.get_node("Chat").AddChat(t, b)
	gui.get_node("Chat").Avance()
	Frenar()

func DialogoD():
	var gui = get_tree().get_first_node_in_group("GUI")
	var t: Array[String] = [
		"¿Por qué el infierno? yo... bueno yo... pero y David, estará realmente acá conmigo... no veo a los demás tripulantes del avión, ni a mi amiga"
	]
	var b: Array[bool] = [
		true
	]
	gui.get_node("Chat").AddChat(t, b)
	gui.get_node("Chat").Avance()
	Frenar()

func DialogoFinal():
	var gui = get_tree().get_first_node_in_group("GUI")
	var t: Array[String] = [
		"Já miren qué cosa más pequeña y jugosa, ha venido más profundo de lo que debería, no comprendo cómo mis diablillos no la han sometido, aún...",
		"Digame si mi esposo David está aquí, señor demonio tenga piedad, debo decirle algo así sea por última vez, ¡piedad!",
		"No debería contestarle algo, pero le diré, no ha llegado David, el infierno abre sus puertas solo a herejes y traidores... Ginna",
		"Yo... no entiendo... bueno quizás si... pero eso fué un error, Michael solo era mi amigo, mejor amigo, ahora comprendo... ahora comprendo",
		"Ginna, Ginna, Ginna, hoy cavas hondo minúscula mortal",
		"Todo por esa noche, yo si amaba a David... y a Michael ¡el infierno es injusto!"
	]
	var b: Array[bool] = [
		false,
		true,
		false,
		true,
		false,
		true
	]
	gui.get_node("Chat").AddChat(t, b)
	gui.get_node("Chat").Avance()
	gui.get_node("Chat").esFinal = true
	Frenar()
	$AudioFinal.play()

func Frenar():
	puedeMover = false
	velocity.x = 0
	$Anima.play("idle")

func _on_invisible_animation_finished(_anim_name):
	$Invisible.play("RESET")
