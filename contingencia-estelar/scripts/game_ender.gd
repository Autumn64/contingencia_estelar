extends StaticBody2D

@onready var hud: CanvasLayer = $"/root/Juego/HUD"
@onready var jugador: CharacterBody2D = $"/root/Juego/Jugador"


func _on_detector_area_entered(area: Area2D) -> void:
	jugador.life_timer.stop()
	jugador.end_animation()
