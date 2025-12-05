extends CharacterBody2D

@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var attack_animation: AnimationPlayer = $AttackAnimation
@onready var attacked_animation: AnimationPlayer = $AttackedAnimation
@onready var dying_timer: Timer = $DyingTimer

var player = null
var life = 100
const damage_factor = 20
const player_damage = 20
var knockback = false

var is_dying = false

func apply_knockback(_direction):
	return

func life_events():
	if life <= 0 and not is_dying:
		dying_timer.start()
		attacked_animation.play("attacked_die")
		if attack_animation.is_playing():
			attack_animation.call_deferred("stop")
	else:
		attacked_animation.play("attacked")
		
func _physics_process(_delta):
	if is_dying:
		velocity = Vector2(0, 0)
		return

func _on_chase_radius_area_entered(area: Area2D) -> void:
	print(area)
	player = area.get_parent()
	sprite.play("attacking")
	if attack_animation.is_playing():
		attack_animation.stop()
	attack_animation.play("attack_loop")

func _on_chase_radius_area_exited(_area: Area2D) -> void:
	player = null
	sprite.play("idle")
	if attack_animation.is_playing():
		attack_animation.call_deferred("stop")
	attack_animation.play("RESET")

func _on_dying_timer_timeout() -> void:
	is_dying = true
