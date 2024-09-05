extends Camera2D

@export var mouse_nudge_distance = 0.2
@export var lock_nudge_distance = 0.8
@export var nudge_speed = 0.1
@onready var player = %Player

var target_location = Vector2()

func _physics_process(_delta):
	if player.locked:
		target_location = player.global_position.lerp(player.target.global_position, lock_nudge_distance)
	else:
		target_location = player.global_position.lerp(get_global_mouse_position(), mouse_nudge_distance)

	global_position = global_position.lerp(target_location, nudge_speed)