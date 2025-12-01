extends CanvasLayer

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

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.
