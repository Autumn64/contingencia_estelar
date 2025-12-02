extends Area2D

@onready var jugador: CharacterBody2D = $"/root/Juego/Jugador"

func _on_body_entered(_body: Node2D) -> void:
	jugador.oxygen = 0
	jugador.life = 0
	jugador.life_events()
