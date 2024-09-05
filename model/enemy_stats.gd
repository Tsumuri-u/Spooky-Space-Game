extends Resource
class_name Enemy

@export var health: int
@export var knockback_threshold: int # weapon's enemy_knockback parameter must be higher than this to apply
@export var knockback_resist: int # multiplier for weapon's knockback distance
@export var stagger_health: int # stagger meter, depleted by weapon's enemy_stagger_damage parameter
@export var stagger_weakness: float # multiplier for weapon's enemy_stagger_time parameter
@export var damage: int # multiplier for enemy's attacks (individual attacks will have motion values)
