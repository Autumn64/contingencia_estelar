extends Area2D

@onready var jugador: CharacterBody2D = $"/root/Juego/Jugador"
@onready var timer: Timer = $Timer

func _on_body_entered(_body: Node2D) -> void:
	timer.start()


func _on_timer_timeout() -> void:
	jugador.life = 0
	jugador.life_events()
