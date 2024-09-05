extends Area2D
class_name Placed

@onready var timer: Timer = $Timer
@onready var sprite_2d: Sprite2D = $Sprite2D
@onready var area_of_effect: CollisionShape2D = $AreaOfEffect

var weapon_params: Weapon
var spawn_position

func _ready() -> void:
	sprite_2d.texture = weapon_params.sprite
	area_of_effect.shape.radius = weapon_params.projectile_radius

	timer.wait_time = weapon_params.timeout

	