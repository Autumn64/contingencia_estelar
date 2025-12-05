extends CharacterBody2D

@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var animation_player_2: AnimationPlayer = $AnimationPlayer2
@onready var attack_shape: Area2D = $AttackShape
@onready var hud: CanvasLayer = $"/root/Juego/HUD"
@onready var jump_audio: AudioStreamPlayer2D = $JumpAudio
@onready var slide_audio: AudioStreamPlayer2D = $SlideAudio
@onready var attack_audio: AudioStreamPlayer2D = $AttackAudio
@onready var damage_audio: AudioStreamPlayer2D = $DamageAudio
@onready var life_timer: Timer = $LifeTimer

@onready var biiblets: Node = $"/root/Juego/Biiblets"
@onready var akritas: Node = $"/root/Juego/Akritas"

var t_espera: float = 0.0
var calculo_inicial: bool = false

const SPEED = 100.0
const JUMP_VELOCITY = -130.0
var life = 100
var oxygen = 60
var acc = 0
var sliding = false
var attacking = false
var can_move = true
var is_ending = false

func reload_level():
	get_tree().reload_current_scene()

func clear_enemies():
	for element in biiblets.get_children():
		element.queue_free()
		
	for element in akritas.get_children():
		element.queue_free()

func player_die() -> void:
	life_timer.stop()
	sprite.play("idle")
	clear_enemies()
	set_process_input(false)
	can_move = false
	velocity = Vector2.ZERO
	hud.fade_to_black()
	animation_player_2.play("dying")

func calcular_vida() -> void:
	if life <= 0:
		hud.dibujar_corazones(0)
		return
	if life < 20:
		hud.dibujar_corazones(1)
		return
	if life >= 20 and life < 40:
		hud.dibujar_corazones(2)
		return
	if life >= 40 and life < 60:
		hud.dibujar_corazones(3)
		return
	if life >= 60 and life < 100:
		hud.dibujar_corazones(4)
		return
	if life == 100:
		hud.dibujar_corazones(5)
		return

func calcular_burbujas() -> void:
	if oxygen <= 0:
		hud.dibujar_burbujas(0)
		return
	if oxygen < 20:
		hud.dibujar_burbujas(1)
		return
	if oxygen >= 20 and oxygen < 40:
		hud.dibujar_burbujas(2)
		return
	if oxygen >= 40 and oxygen < 60:
		hud.dibujar_burbujas(3)
		return
	if oxygen >= 60 and oxygen < 80:
		hud.dibujar_burbujas(4)
		return
	if oxygen >= 80 and oxygen <= 100:
		hud.dibujar_burbujas(5)
		return

func life_events():
	calcular_burbujas()
	calcular_vida()
	if life <= 0:
		player_die()

func player_automove() -> void:
	is_ending = true
	
func player_autostop() -> void:
	sprite.play("idle")
	is_ending = false
	can_move = false #para que el personaje no se pueda mover

func end_game() -> void:
	hud.end_game()

func end_animation() -> void:
	if animation_player_2.is_playing():
		animation_player_2.stop()
	animation_player_2.play("end_cutscene")

func attack_event():
	if not can_move or is_ending: return
	attacking = true
	if is_on_floor():
		sprite.play("attacking_running" if velocity.x != 0 else "attacking_idle")
	else:
		sprite.play("attacking_jumping")

func apply_knockback(force: Vector2) -> void:
	velocity = force

func onair_physics(delta: float) -> void:
	if not can_move: return
	acc = 1.3
	velocity += get_gravity() * delta
	
	if attacking: return
	
	if sprite.animation != "jumping":
		sprite.play("jumping")
	
	if (Input.is_action_just_pressed("slide") and velocity.x != 0) and not sliding and not is_ending:
		sprite.stop()
		sprite.play("jumping")
		slide_audio.play()
		velocity.y = -130
		sliding = true
		if oxygen > 0: oxygen -= 4
		life_events()

func onfloor_physics() -> void:
	if not can_move: return
	acc = 2.0
	sliding = false
	
	if attacking: return
	
	# Animation
	if velocity.x != 0:
		var vel = Input.get_action_strength("move_right") - Input.get_action_strength("move_left")
		sprite.play("running", vel)
	else:
		sprite.play("idle")
	
	# Handle jump.
	if Input.is_action_just_pressed("jump") and not is_ending:
		sprite.play("jumping")
		jump_audio.play()
		velocity.y = JUMP_VELOCITY


func _physics_process(delta: float) -> void:
	if not can_move: return
	# Add the gravity.
	if not is_on_floor():
		onair_physics(delta)
	else: 
		onfloor_physics()
		
	if Input.is_action_just_pressed("attack") and not attacking and not is_ending:
		animation_player.play("attack")
		attack_audio.play()
		attack_event()
		
	# Get the input direction and handle the movement/deceleration.
	var direction := 0
	if Input.is_action_pressed("move_left") and not is_ending:
		direction -= 1
	if Input.is_action_pressed("move_right") and not is_ending:
		direction += 1
	if is_ending:
		direction += 1
	if is_ending and is_on_floor():
		sprite.play("running")
	if is_ending and not is_on_floor():
		sprite.play("jumping")
	if direction:
		sprite.flip_h = (direction < 0)
		attack_shape.scale.x = -1 if (direction < 0) else 1
		velocity.x = move_toward(velocity.x, direction * SPEED, SPEED * acc * delta)
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED * acc * delta)

	move_and_slide()

func _on_life_timer_timeout() -> void:
	if oxygen <= 0:
		life -= 10
	else:
		oxygen -= 10
	life_events()

func _on_animated_sprite_2d_animation_finished() -> void:
	if "attacking" in sprite.animation:
		animation_player.play("RESET")
		attacking = false

func _on_attack_shape_area_entered(area: Area2D) -> void:
	var enemy = area.get_parent()
	var damagezone = enemy.get_node("./DamageZone")
	var direction: Vector2 = (global_position - enemy.global_position).normalized()
	enemy.life -= enemy.damage_factor
	enemy.life_events()
	enemy.knockback = true
	enemy.apply_knockback(direction * -150)
	
	damagezone.start_timer()

# Espera 1 milisegundo a calcular las burbujas para dejar que cargue el HUD
func _process(delta) -> void:
	t_espera += delta
	if t_espera >= 0.1 and not calculo_inicial:
		calculo_inicial = true
		life_events()
		hud.show_label()

func _on_animation_player_2_animation_finished(anim_name: StringName) -> void:
	if anim_name == "damaged":
		animation_player_2.play("RESET")
	#if anim_name == "dying":
		#get_tree().reload_current_scene()

func _on_ready() -> void:
	var level = Globals.levels[Globals.current_level]
	set_global_position(level["position"])
