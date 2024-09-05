extends Area2D

@onready var reticle_locked: Sprite2D = $ReticleLocked
@onready var reticle_looking: Sprite2D = $ReticleLooking

func show_looking():
	reticle_looking.show()

func hide_looking():
	reticle_looking.hide()

func show_locked():
	reticle_locked.show()

func hide_locked():
	reticle_locked.hide()
