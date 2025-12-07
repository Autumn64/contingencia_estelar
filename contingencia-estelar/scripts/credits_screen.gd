extends CanvasLayer

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("enter"):
		get_tree().change_scene_to_file("res://scenes/title_screen.tscn")
