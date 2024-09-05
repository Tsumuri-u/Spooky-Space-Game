extends Node

@export var WEAPON: Weapon

@onready var main = get_tree().get_root().get_node("Game")
@onready var weapon_sprite: Sprite2D = $Sprite2D

var durability: int

func _ready() -> void:
	if !WEAPON:
		pass
	else:
		display()

func display() -> void:
	weapon_sprite.texture = WEAPON.sprite
	durability = WEAPON.durability

func undisplay():
	weapon_sprite.texture = null

func fire():
	var projectile = WEAPON.projectile.instantiate()
	projectile.weapon_params = WEAPON

	if projectile is Bullet:
		projectile.spawn_position = self.global_position
		projectile.spawn_rotation = self.global_rotation
		if get_parent().locked == true:
			projectile.target = get_parent().target
		
	if projectile is Bullet || projectile is Placed:
		main.add_child.call_deferred(projectile)
	
	if projectile is Melee:
		add_child(projectile)
