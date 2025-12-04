extends CharacterBody2D

@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var attacked_animation: AnimationPlayer = $AttackedAnimation

var run_speed = 40
var player = null
var knockback = false
var life = 100
const damage_factor = 40
const player_damage = 10

var is_dying := false

# Si no detecta al jugador se moverá aleatoriamente
var wander_target: Vector2
var wander_range_x := 50
var wander_range_y := 10
var wander_speed := 10 

func die_effect():
	velocity = Vector2.ZERO
	run_speed = 0

	var tween := create_tween()

	for i in range(3):
		tween.tween_property(sprite, "modulate", Color(1, 0.2, 0.2), 0.08)
		tween.tween_property(sprite, "modulate", Color(1, 1, 1), 0.08)

	tween.tween_property(sprite, "modulate", Color(1, 0, 0), 0.15)

	var back_dir = -Vector2(cos(sprite.rotation), sin(sprite.rotation)) * 40
	tween.tween_property(self, "position", position + back_dir, 0.2)\
		.set_trans(Tween.TRANS_SINE)\
		.set_ease(Tween.EASE_OUT)

	tween.tween_callback(func():
		attacked_animation.play("attacked_die")
	)

func life_events():
	if life <= 0 and not is_dying:
		is_dying = true
		die_effect()
	else:
		attacked_animation.play("attacked")

func wander():
	if position.distance_to(wander_target) < 5:
		set_wander_target()
	velocity = position.direction_to(wander_target) * wander_speed
	sprite.flip_v = (velocity.x < 0)

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
		sprite.flip_v = false
		sprite.rotation = velocity.angle()
	else:
		sprite.flip_v = true
		sprite.rotation = velocity.angle()
	move_and_slide()

func _on_chase_radius_area_entered(area: Area2D) -> void:
	player = area.get_parent()
	sprite.play("attack_begin")

func _on_chase_radius_area_exited(_area: Area2D) -> void:
	player = null
	sprite.play("attack_finish")

func _on_animated_sprite_2d_animation_finished() -> void:
	if sprite.animation == "attack_begin":
		sprite.play("attacking")
		run_speed = 95
	
	if sprite.animation == "attack_finish":
		sprite.play("idle")
		run_speed = 40
