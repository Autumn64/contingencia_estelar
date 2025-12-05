extends CanvasLayer
@onready var start: Label = $CenterContainer/Start

@onready var options := {
	1: $Opt1,
	2: $Opt2
}

var selected_option = 1

func change_screen() -> void:
	if selected_option == 1:
		get_tree().change_scene_to_file("res://scenes/juego.tscn")
	elif selected_option == 2:
		get_tree().change_scene_to_file("res://scenes/credits_screen.tscn")

func change_label() -> void:
	for i in range(1, 3):
		options[i].visible = false
		
	options[selected_option].visible = true
	
func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("select_down") and selected_option == 1:
		selected_option = 2
		change_label()
		return
	if Input.is_action_just_pressed("select_down") and selected_option == 2:
		selected_option = 1
		change_label()
		return
	
	if Input.is_action_just_pressed("select_up") and selected_option == 1:
		selected_option = 2
		change_label()
		return
	if Input.is_action_just_pressed("select_up") and selected_option == 2:
		selected_option = 1
		change_label()
		return
		
	if Input.is_action_just_pressed("enter"):
		change_screen()

func _ready() -> void:
	change_label()
