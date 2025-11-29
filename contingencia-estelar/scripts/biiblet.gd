extends CharacterBody2D

@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D

var run_speed = 25
var player = null
var knockback = false
var life = 100
var damage_factor = 50

# Si no detecta al jugador se moverá aleatoriamente
var wander_target: Vector2
var wander_range_x := 50
var wander_range_y := 20
var wander_speed := 15 

func life_events():
	if life <= 0: queue_free()

func wander():
	if position.distance_to(wander_target) < 5:
		set_wander_target()
	velocity = position.direction_to(wander_target) * wander_speed
	sprite.flip_h = velocity.x < 0

func set_wander_target():
	var random_offset = Vector2(
		randf_range(-wander_range_x, wander_range_x),
		randf_range(-wander_range_y, wander_range_y)
	)
	wander_target = position + random_offset

func _on_ready() -> void:
	set_wander_target()

func apply_knockback(force: Vector2) -> void:
	velocity = force

func _physics_process(_delta):
	if not player:
		if get_slide_collision_count() > 0: set_wander_target()
		wander()
		
	if player and not knockback:
		velocity = position.direction_to(player.position) * run_speed
		
	if velocity.x > 0:
		sprite.rotation = velocity.angle() + (PI/2) - 0.2
	else:
		sprite.rotation = velocity.angle() + (PI/2) + 0.1
	move_and_slide()

func _on_chase_radius_body_entered(body: Node2D) -> void:
	player = body
	sprite.play("attacking")

func _on_chase_radius_body_exited(_body: Node2D) -> void:
	player = null
	sprite.play("idle")
	set_wander_target()
