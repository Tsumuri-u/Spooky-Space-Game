extends State

@export var actor: CharacterBody2D

func Enter():
	pass
	
func Physics_Update(_delta):
	actor.look_at(actor.get_global_mouse_position())
	actor.velocity = actor.velocity.move_toward(Vector2.ZERO, actor.speed)

func Exit():
	pass