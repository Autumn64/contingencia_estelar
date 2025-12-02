extends CanvasLayer

@onready var animation_player: AnimationPlayer = $"/root/Juego/AnimationPlayer"
@onready var titulo: Label = $"/root/Juego/HUD/CenterContainer/Titulo"

var time_elapsed: float = 0.0

func reset_time():
	time_elapsed = 0.0

func fade_to_black():
	animation_player.stop()
	animation_player.play("fade_out")

func level_change():
	var level = Globals.levels[Globals.current_level]
	level["completion_time"] = time_elapsed
	print("Nivel " + str(Globals.current_level) + ": " + str(level["completion_time"]))
	reset_time()
	Globals.current_level += 1
	show_label()
	
func show_label():
	var level = Globals.levels[Globals.current_level]
	titulo.text = level["label"]
	animation_player.play("show_title")

@onready var burbujas: Array = [
	$"Burbujas/b-1",
	$"Burbujas/b-2",
	$"Burbujas/b-3",
	$"Burbujas/b-4",
	$"Burbujas/b-5",
]

@onready var corazones: Array = [
	$"Corazones/c-1",
	$"Corazones/c-2",
	$"Corazones/c-3",
	$"Corazones/c-4",
	$"Corazones/c-5"
]

func dibujar_corazones(cant: int) -> void:
	assert(cant <= 5 and cant >= 0)
	
	var i = 0
	
	while i < cant:
		corazones[i].play("default")
		i += 1
	
	while i < 5:
		corazones[i].play("disabled")
		i += 1

func dibujar_burbujas(cant: int) -> void:
	assert(cant <= 5 and cant >= 0)
	
	var i = 0
	
	while i < cant:
		burbujas[i].visible = true
		i += 1
	
	while i < 5:
		burbujas[i].visible = false
		i += 1

func _process(delta: float) -> void:
	time_elapsed += delta
