extends Area2D

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var jugador: CharacterBody2D = $"/root/Juego/Jugador"

func _on_body_entered(_body: Node2D) -> void:
	animation_player.play("pickup")
	jugador.oxygen += 8
	jugador.life_events()
