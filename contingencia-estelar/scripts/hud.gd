extends CanvasLayer

@onready var animation_player: AnimationPlayer = $"/root/Juego/AnimationPlayer"
@onready var animation_player_2: AnimationPlayer = $"../AnimationPlayer2"
@onready var titulo: Label = $"/root/Juego/HUD/CenterContainer/Titulo"
@onready var primer_nivel: Label = $"CenterContainer2/Primer nivel"
@onready var segundo_nivel: Label = $"CenterContainer3/Segundo nivel"
@onready var tercer_nivel: Label = $"CenterContainer4/Tercer nivel"
@onready var puntuacion: Label = $CenterContainer5/Puntuacion

var time_elapsed: float = 0.0

func reset_time():
	time_elapsed = 0.0

func fade_to_black():
	if animation_player.is_playing():
		animation_player.stop()
	animation_player.play("fade_out")

func set_punctuation():
	var template = "Tardaste %.2f seg .  en el capítulo %s: %s puntos."
	primer_nivel.text =  template % [Globals.levels[1]["completion_time"], 1, Globals.levels[1]["points"]]
	segundo_nivel.text =  template % [Globals.levels[2]["completion_time"], 2, Globals.levels[2]["points"]]
	tercer_nivel.text =  template % [Globals.levels[3]["completion_time"], 3, Globals.levels[3]["points"]]
	
	var puntuacion_total = Globals.levels[1]["points"] + Globals.levels[2]["points"] + Globals.levels[3]["points"]
	puntuacion.text = "Puntuación total: " + str(puntuacion_total)
	
	if animation_player_2.is_playing():
		animation_player_2.stop()
	animation_player_2.play("show_result")

func end_game():
# Calcula la puntuación de cada nivel
	var level = Globals.levels[Globals.current_level]
	level["completion_time"] = time_elapsed
	reset_time()
	print("Nivel " + str(Globals.current_level) + ": " + str(level["completion_time"]))
	fade_to_black()
	for i in range (1, 4):
		var time_factor = Globals.time_limit - Globals.levels[i]["completion_time"]
		if time_factor < 0: time_factor = 0
		Globals.levels[i]["points"] = int(time_factor * Globals.points_factor)
		
	titulo.text = "Ya estás a salvo ,  por ahora . . ."
	set_punctuation()

func level_change():
	var level = Globals.levels[Globals.current_level]
	level["completion_time"] = snapped(time_elapsed, 0.01)
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
