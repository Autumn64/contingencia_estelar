extends CharacterBody2D

@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D

const SPEED = 100.0
const JUMP_VELOCITY = -130.0
var life = 100
var acc = 0
var sliding = false

func life_events():
	if life <= 0:
		get_tree().reload_current_scene()

func onair_physics(delta: float) -> void:
	acc = 0.5
	velocity += get_gravity() * delta
	
	if sprite.animation != "jumping":
		sprite.play("jumping")
	
	if (Input.is_action_just_pressed("slide") and velocity.x != 0) and not sliding:
		velocity.y = -130
		sliding = true

func onfloor_physics() -> void:
	acc = 2.0
	sliding = false
	
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
	
	# Get the input direction and handle the movement/deceleration.
	var direction := Input.get_axis("move_left", "move_right")
	if direction:
		sprite.flip_h = (direction < 0)
		velocity.x = move_toward(velocity.x, direction * SPEED, SPEED * acc * delta)
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED * acc * delta)

	move_and_slide()

func _on_life_timer_timeout() -> void:
	life += -10
	print(life)
	life_events()
