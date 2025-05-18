extends Node2D

const AUDLIM: float = 500
const INFO: String = "W\nA      D\nespacio\nvol: -$+"
const entes = [
	preload("res://Scenes/Obstaculos/Babosa.tscn"),
	preload("res://Scenes/Obstaculos/Feto.tscn"),
	preload("res://Scenes/Obstaculos/Gula.tscn"),
	preload("res://Scenes/Obstaculos/Infante.tscn"),
	preload("res://Scenes/Obstaculos/Lengua.tscn"),
	preload("res://Scenes/Obstaculos/Llorona.tscn"),
	preload("res://Scenes/Obstaculos/Ninno.tscn"),
	preload("res://Scenes/Vida.tscn")
]

var babosas: Array[Vector2] = []
var fetos: Array[Vector2] = []
var gulas: Array[Vector2] = []
var infantes: Array[Vector2] = []
var lenguas: Array[Vector2] = []
var lloronas: Array[Vector2] = []
var ninnos: Array[Vector2] = []
var vidas: Array[Vector2] = []

var instancias = [
	["Babosa", babosas],
	["Feto", fetos],
	["Gula", gulas],
	["Infante", infantes],
	["Lengua", lenguas],
	["Llorona", lloronas],
	["Ninno", ninnos],
	["Vida", vidas]
]

var volumen: float = 1

func _ready():
	randomize()
	# obtener todas las entidades del mundo
	for tipo in instancias:
		for ins in get_tree().get_nodes_in_group(tipo[0]):
			tipo[1].append(ins.position)
	AudioLimit()
	SetVolumen()
	$Informacion.visible = false

func Respawn():
	# eliminar a las actuales
	for tipo in instancias:
		for ins in get_tree().get_nodes_in_group(tipo[0]):
			ins.queue_free()
	# crear a las nuevas
	var aux
	var n = 0
	for tipo in instancias:
		for pos in tipo[1]:
			aux = entes[n].instantiate()
			if n == 7:
				$Trampas.add_child(aux)
			else:
				$Monstruos.add_child(aux)
			aux.position = pos
		n += 1
	AudioLimit()

func _on_musica_finished():
	$Musica.play()

func AudioLimit():
	for aud in get_tree().get_nodes_in_group("Audio"):
		aud.max_distance = AUDLIM

func _input(event):
	if event.is_action_pressed("com_volup"):
		volumen = min(1, volumen + 0.1)
		SetVolumen()
	elif event.is_action_pressed("com_voldown"):
		volumen = max(0, volumen - 0.1)
		SetVolumen()

func SetVolumen():
	AudioServer.set_bus_volume_db(
		AudioServer.get_bus_index("Master"),
		linear_to_db(volumen))
	$Instrucciones.text = INFO.replace("$", str(round(volumen * 100)))
