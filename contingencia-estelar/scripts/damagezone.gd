extends Area2D
class_name DamageZone

@onready var parent: CharacterBody2D = $".."
@onready var jugador: CharacterBody2D = $"/root/Juego/Jugador"
@onready var timer: Timer = $Timer

func start_timer() -> void:
	if timer.is_stopped():
		timer.start()

func _on_body_entered(_body: Node2D) -> void:
		jugador.life -= 5
		print(jugador.life)
		var direction := (jugador.global_position - global_position).normalized()
		jugador.apply_knockback(direction * 150)
		
		parent.knockback = true
		parent.apply_knockback(direction * -50)
		start_timer()

func _on_timer_timeout() -> void:
	parent.knockback = false
