extends Node2D

@export var weapon: Weapon

@onready var sprite: Sprite2D = $Sprite2D
var instance

func _ready() -> void:
	sprite.texture = weapon.sprite
	pass

# when player collides with pickup
func _on_area_2d_body_entered(body:Node2D) -> void:
	if body.has_method("pickup_weapon"):
		body.pickup_weapon(weapon)
	queue_free()
