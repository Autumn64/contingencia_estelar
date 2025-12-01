extends Area2D
class_name DamageZone

@onready var parent: CharacterBody2D = $".."
@onready var jugador: CharacterBody2D = $"/root/Juego/Jugador"
@onready var timer: Timer = $Timer

func start_timer() -> void:
	if timer.is_stopped():
		timer.start()

func _on_area_entered(_area: Area2D) -> void:
	jugador.life -= 5
	jugador.damage_audio.play()
	var direction := jugador.global_position - global_position
	if direction.length() < 16.0:
		direction = Vector2.RIGHT.rotated(randf() * TAU) * 2
	direction = direction.normalized()
	jugador.apply_knockback(direction * 150)
	jugador.animation_player_2.play("damaged")
	jugador.life_events()
		
	parent.knockback = true
	
	parent.apply_knockback(direction * -50)
	start_timer()

func _on_timer_timeout() -> void:
	parent.knockback = false
