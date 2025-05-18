extends Node2D

var textos: Array[String] = []
var caraA: Array[bool] = []
var estado: int = -1
var esFinal: bool = false

var tiempoPausa: float = 0

func _ready():
	tiempoPausa = $Pausa.wait_time
	get_parent().get_parent().visible = true
	Avance()

func _input(event):
	if event.is_action_pressed("com_next"):
		if $Pausa.is_stopped() and estado != -1:
			Avance()

func IsFree():
	return estado == -1 and not esFinal

func AddOne(texto: String, isA: bool):
	textos.append(texto)
	caraA.append(isA)

func AddChat(texto: Array[String], isA: Array[bool]):
	textos = texto
	caraA = isA

func Clear():
	textos = []
	caraA = []
	# eliminar espectro y poner creditos
	if esFinal:
		get_parent().get_parent().get_parent().get_node("Informacion").visible = true
		
	else:
		get_tree().get_first_node_in_group("Espectro").visible = false

func Avance():
	if estado == -1:
		if textos.size() > 0:
			estado = 0
	else:
		estado += 1
		if estado >= textos.size():
			estado = -1
	if estado == -1:
		visible = false
		Clear()
	else:
		visible = true
		$Texto.text = textos[estado]
		$Player.visible = caraA[estado]
		$Jefe.visible = not caraA[estado]
		if caraA[estado]:
			$Texto.self_modulate = Color8(180, 200, 240) # azul
		else:
			$Texto.self_modulate = Color8(240, 140, 180) # rojo
		if estado == 0:
			$Pausa.start(tiempoPausa * 2)
		else:
			$Pausa.start(tiempoPausa)
