extends RigidBody2D

@export var stats: Enemy

@onready var stagger_timer: Timer = $StaggerTimer

var health: int
var stagger: int
var staggered: bool = false

signal health_depleted

func _ready() -> void:
	stagger = stats.stagger_health
	health = stats.health

func _process(_delta):
	# need this for player lockon and bullets to work
	_check_health()

func _physics_process(_delta: float) -> void:

	# time to stop based on knockback resist
	apply_central_force(-linear_velocity * stats.knockback_resist)

func _on_hurtbox_area_entered(area:Area2D) -> void:
	_handle_taking_damage(area)
	_handle_knockback(area)
	_handle_stagger(area)

func _handle_taking_damage(area):
	if area is Bullet:
		health -= area.weapon_params.damage
		stagger -= area.weapon_params.enemy_stagger_damage
		print(stats.stagger_health, ", ", area.weapon_params.enemy_stagger_damage)

func _handle_knockback(area):
	if area.weapon_params.enemy_knockback_damage >= stats.knockback_threshold:
		var directionTo = Vector2.DOWN.rotated(area.global_rotation)
		apply_central_impulse(directionTo * -area.weapon_params.enemy_knockback_amount)

func _check_health():
	if stats.health <= 0:
		health_depleted.emit()
		queue_free()

func _handle_stagger(area):
	if stats.stagger_health <= 0:
		staggered = true
		stagger_timer.wait_time = area.weapon_params.enemy_stagger_time * stats.stagger_weakness
		stagger_timer.start()
		print("staggered")

func _on_stagger_timer_timeout() -> void:
	staggered = false
	stagger = stats.stagger_health
	print("stagger recovered")
