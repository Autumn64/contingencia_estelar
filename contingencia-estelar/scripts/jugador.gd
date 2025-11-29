extends CharacterBody2D

@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var attack_shape: Area2D = $AttackShape

const SPEED = 100.0
const JUMP_VELOCITY = -130.0
var life = 100
var acc = 0
var sliding = false
var attacking = false

func life_events():
	print(life)
	if life <= 0:
		get_tree().reload_current_scene()

func attack_event():
	attacking = true
	if is_on_floor():
		sprite.play("attacking_running" if velocity.x != 0 else "attacking_idle")
	else:
		sprite.play("attacking_jumping")

func apply_knockback(force: Vector2) -> void:
	velocity = force

func onair_physics(delta: float) -> void:
	acc = 1.3
	velocity += get_gravity() * delta
	
	if attacking: return
	
	if sprite.animation != "jumping":
		sprite.play("jumping")
	
	if (Input.is_action_just_pressed("slide") and velocity.x != 0) and not sliding:
		sprite.stop()
		sprite.play("jumping")
		velocity.y = -130
		sliding = true

func onfloor_physics() -> void:
	acc = 2.0
	sliding = false
	
	if attacking: return
	
	# Animation
	if velocity.x != 0:
		sprite.play("running")
	else:
		sprite.play("idle")
	
	# Handle jump.
	if Input.is_action_just_pressed("jump"):
		sprite.play("jumping")
		velocity.y = JUMP_VELOCITY


func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		onair_physics(delta)
	else: 
		onfloor_physics()
		
	if Input.is_action_just_pressed("attack"):
		animation_player.play("attack")
		attack_event()
		
	# Get the input direction and handle the movement/deceleration.
	var direction := Input.get_axis("move_left", "move_right")
	if direction:
		sprite.flip_h = (direction < 0)
		attack_shape.scale.x = -1 if (direction < 0) else 1
		velocity.x = move_toward(velocity.x, direction * SPEED, SPEED * acc * delta)
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED * acc * delta)

	move_and_slide()

func _on_life_timer_timeout() -> void:
	life += -10
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
	enemy.apply_knockback(direction * -80)
	
	damagezone.start_timer()
