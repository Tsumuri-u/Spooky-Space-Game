extends Area2D
class_name Melee

@onready var melee_sprite: Sprite2D = $MeleeSprite
@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D

var weapon_params: Weapon
var spawn_position
var spawn_rotation
var velocity
var final_rotation

func _ready():
	melee_sprite.texture = weapon_params.projectile_sprite
	collision_shape_2d.shape.size = Vector2(10, weapon_params.projectile_radius)
	global_position = spawn_position

	match weapon_params.melee_pattern:
		weapon_params.MELEE_PATTERN.THRUST:
			global_rotation = spawn_rotation
		weapon_params.MELEE_PATTERN.SWEEP:
			global_rotation = spawn_rotation + PI/3
			final_rotation = spawn_rotation - PI/3
		weapon_params.MELEE_PATTERN.SPIN:
			global_position = spawn_rotation + PI/2
			final_rotation = spawn_rotation - 3*PI/2
		
	if weapon_params.startup == 0:
		velocity = weapon_params.velocity
	else:
		velocity = 0

func _physics_process(_delta):
	if velocity < weapon_params.velocity:
		velocity += (1/weapon_params.startup) * weapon_params.velocity
	
	if weapon_params.melee_pattern == weapon_params.MELEE_PATTERN.THRUST:
		position += Vector2(0, -velocity).rotated(spawn_rotation)
	else:
		global_rotation -= velocity
	
