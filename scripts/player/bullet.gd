extends Area2D
class_name Bullet

@onready var timeout: Timer = $Timeout
@onready var sprite_2d: Sprite2D = $BulletSprite
@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D

var weapon_params: Weapon
var spawn_position
var spawn_rotation
var target
var velocity
var target_distance_old = INF
var target_distance_new

func _ready() -> void:

	# set bullet sprite, hitbox, initial rotation, position, timeout time
	sprite_2d.texture = weapon_params.projectile_sprite
	collision_shape_2d.shape.radius = weapon_params.projectile_radius
	global_position = spawn_position
	global_rotation = spawn_rotation
	timeout.wait_time = weapon_params.timeout

	# check if bullet needs to accelerate
	if weapon_params.startup == 0:
		velocity = weapon_params.velocity
	else:
		velocity = 0

	timeout.start()

func _physics_process(_delta):
	# accelerate bullet every frame
	if velocity < weapon_params.velocity:
		velocity += (1/weapon_params.startup) * weapon_params.velocity

	if target != null && weapon_params.homing_drag != 0:
		# addition of angle must be on angleTo
		var angleTo = global_position.direction_to(target.global_position).angle() + PI/2
		angleTo = lerp_angle(global_rotation, angleTo, 1/float(weapon_params.homing_drag))
		global_rotation = angleTo

		target_distance_new = global_position.distance_to(target.global_position)

		if target_distance_old - target_distance_new < 0:
			target = null
		else:
			target_distance_old = target_distance_new

	global_position += Vector2(0, -velocity).rotated(global_rotation)
		

func _on_area_entered(_area:Area2D) -> void:
	queue_free()
	

func _on_timeout_timeout() -> void:
	queue_free()
