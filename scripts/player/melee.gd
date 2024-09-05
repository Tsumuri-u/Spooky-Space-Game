extends Area2D
class_name Melee

@onready var timeout: Timer = $Timeout
@onready var melee_sprite: Sprite2D = $MeleeSprite
@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D

var weapon_params: Weapon
var velocity
var final_rotation
var thrusting: int = 3 #0 means needs to retract, 1 means pausing, 2 means start pause, 3 means thrusting

func _ready():
	melee_sprite.texture = weapon_params.projectile_sprite
	collision_shape_2d.shape.size = Vector2(20, weapon_params.projectile_radius)
	timeout.wait_time = weapon_params.timeout

	match weapon_params.melee_pattern:
		weapon_params.MELEE_PATTERN.SWEEP:
			melee_sprite.position.y -= weapon_params.projectile_radius
			collision_shape_2d.position.y -= weapon_params.projectile_radius
			rotation += PI/4
			final_rotation = -PI/4
		weapon_params.MELEE_PATTERN.SPIN:
			melee_sprite.position.y -= weapon_params.projectile_radius
			collision_shape_2d.position.y -= weapon_params.projectile_radius
			rotation += PI/2
			final_rotation = -3*PI/2
		
	if weapon_params.startup == 0:
		velocity = weapon_params.velocity
	else:
		velocity = 0

func _physics_process(_delta):
	if velocity < weapon_params.velocity:
		velocity += (1/weapon_params.startup) * weapon_params.velocity
	
	if weapon_params.melee_pattern == weapon_params.MELEE_PATTERN.THRUST:
		if thrusting == 3:
			position += Vector2(0, -velocity)
			if position.y <= -(melee_sprite.texture.get_height() - 5):
				thrusting = 2
		if thrusting == 2:
			timeout.start()
			thrusting = 1
		if thrusting == 0:
			collision_shape_2d.disabled = true
			position -= Vector2(0, -velocity)
			if position.y >= 0:
				queue_free()
	if weapon_params.melee_pattern == weapon_params.MELEE_PATTERN.SWEEP || weapon_params.melee_pattern == weapon_params.MELEE_PATTERN.SPIN:
		rotation -= velocity * 0.01
		if rotation <= final_rotation:
			queue_free()

func _on_timeout_timeout() -> void:
	thrusting = 0
