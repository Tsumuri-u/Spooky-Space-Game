extends Resource
class_name Weapon

enum WEAPON_TYPE { PROJECTILE, PLACE, MELEE }
enum MELEE_PATTERN { NONE, THRUST, SWEEP, SPIN }

@export var name: StringName
@export var sprite: Texture2D

@export var projectile: PackedScene
@export var projectile_sprite: Texture2D
@export var projectile_radius: int # radius of projectile hitbox

@export var type: WEAPON_TYPE
@export var melee_pattern: MELEE_PATTERN

@export var startup: float # physics frames before weapon reaches max velocity or before explosion
@export var velocity: int # max speed
@export var damage: int
@export var recovery: float # time in s before reuse
@export var recoil_force: int # force at which player is sent back upon fire
@export var recoil_time: float # time in s player recoils for
@export var enemy_knockback_damage: int # knockback threshold
@export var enemy_knockback_amount: int # knockback distance
@export var enemy_stagger_damage: int # stagger damage done to an enemy
@export var enemy_stagger_time: float # time target is immobile upon hit
@export var durability: int # num uses before break
@export var homing_drag: int # amount weapon resists homing

@export var timeout: float = 5 # time before projectile despawns