extends StaticBody2D
@onready var hud: CanvasLayer = $"/root/Juego/HUD"

func _on_detector_area_entered(_area: Area2D) -> void:
	hud.level_change()
