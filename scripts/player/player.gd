class_name Player extends CharacterBody2D

@export var speed: int = 10
@export var max_speed: int = 100
@export var boost_speed: int = 300
@export var fcs_range: int = 200

@onready var sprite_2d = $Sprite2D
@onready var fcs = $FCS
@onready var fcsindicator: Sprite2D = $FCS/FCSIndicator
@onready var boost_timer = $BoostTimer
@onready var lweapon: Node2D = %LWeapon
@onready var rweapon: Node2D = %RWeapon
@onready var lrecovery: Timer = $LWeapon/LRecovery
@onready var rrecovery: Timer = $RWeapon/RRecovery
@onready var recoil_timer: Timer = $RecoilTimer

var boosting = false
var can_boost = true
var locked = false
var can_fire_left = true
var can_fire_right = true
var can_move = true
var target

func _ready() -> void:
	_add_fcs(fcs_range)

func _process(_delta):

	_connect_enemy_death_signal()
	_handle_enemy_temp_reticle()
	_handle_weapon_destruction()


func _physics_process(_delta):

	_handle_lookat()
	_handle_movement()
	_handle_boost()
	_handle_lockon()
	_handle_weapon_firing()
	_handle_lockoff()

	move_and_slide()
	
func _add_fcs(new_range:int):
	fcs.target_position = Vector2(new_range, 0)
	fcsindicator.position = Vector2(fcs.target_position.x, 0)

func _handle_lookat():
	# look at target or mouse
	if locked:
		look_at(target.global_position)
	else:
		look_at(get_global_mouse_position())

func _handle_movement():
	# decelerate player
	var moving = Input.is_action_pressed("move_right") || \
				 Input.is_action_pressed("move_left") || \
				 Input.is_action_pressed("move_up") || \
				 Input.is_action_pressed("move_down")
	
	if !moving || !can_move:
		velocity = velocity.move_toward(Vector2.ZERO, speed)
	
	# otherwise accelerate player
	if can_move:
		if Input.is_action_pressed("move_right"):
			velocity.x += speed
			velocity.x = min(velocity.x, max_speed)
			if boosting:
				velocity.x = boost_speed
		if Input.is_action_pressed("move_left"):
			velocity.x -= speed
			velocity.x = max(velocity.x, -max_speed)
			if boosting:
				velocity.x = -boost_speed
		if Input.is_action_pressed("move_down"):
			velocity.y += speed
			velocity.y = min(velocity.y, max_speed)
			if boosting:
				velocity.y = boost_speed
		if Input.is_action_pressed("move_up"):
			velocity.y -= speed
			velocity.y = max(velocity.y, -max_speed)
			if boosting:
				velocity.y = -boost_speed
	
func _handle_boost():
	if Input.is_action_just_pressed("boost") && can_boost:
		boosting = true
		boost_timer.start()
		can_boost = false

func _handle_lockon():
	if Input.is_action_just_pressed("lock_on"):
		if locked:
			locked = false
			if target:
				target.hide_locked()
		else:
			if fcs.is_colliding():
				target = fcs.get_collider()
				locked = true
				target.show_locked()

func _handle_lockoff():
	if locked && !fcs.is_colliding():
		locked = false
		target.hide_locked()
		target.hide_looking()
		target = null

func _handle_weapon_firing():
	if Input.is_action_just_pressed("shoot_left"):
		if lweapon.WEAPON != null && can_fire_left:
			lweapon.fire()
			if lweapon.WEAPON.recovery != 0:
				lrecovery.wait_time = lweapon.WEAPON.recovery
				can_fire_left = false
				lrecovery.start()

			if lweapon.WEAPON.recoil_force != 0:
				_apply_recoil(lweapon.WEAPON.recoil_force, lweapon.WEAPON.recoil_time)
			
			lweapon.durability -= 1

	if Input.is_action_just_pressed("shoot_right"):
		if rweapon.WEAPON != null && can_fire_right:
			rweapon.fire()
			if rweapon.WEAPON.recovery != 0:
				rrecovery.wait_time = rweapon.WEAPON.recovery
				can_fire_right = false
				rrecovery.start()
			if rweapon.WEAPON.recoil_force != 0:
				_apply_recoil(rweapon.WEAPON.recoil_force, rweapon.WEAPON.recoil_time)
			
			rweapon.durability -= 1

func _handle_weapon_destruction():
	if lweapon.WEAPON != null && lweapon.durability <= 0:
		lweapon.WEAPON = null
		lweapon.undisplay()
	
	if rweapon.WEAPON != null && rweapon.durability <= 0:
		rweapon.WEAPON = null
		rweapon.undisplay()

func _handle_enemy_temp_reticle():
	# temp lockon reticle if looking at enemy
	if !locked && fcs.is_colliding():
		target = fcs.get_collider()
		if target != null:
			target.show_looking()
	elif target:
		target.hide_looking()

func _connect_enemy_death_signal():
	if target && !target.get_parent().health_depleted.is_connected(_on_enemy_death):
		target.get_parent().health_depleted.connect(_on_enemy_death)

func _apply_recoil(distance: int, time: float):
	var recoil_direction = Vector2(1, 0).rotated(rotation + PI)

	velocity += recoil_direction * distance
	can_move = false
	can_fire_left = false
	can_fire_right = false
	recoil_timer.wait_time = time
	recoil_timer.start()

func pickup_weapon(weapon):
	if !lweapon.WEAPON:
		lweapon.WEAPON = weapon
		lweapon.display()
	elif !rweapon.WEAPON:
		rweapon.WEAPON = weapon
		rweapon.display()
	else:
		print("No space for new weapons")

func _on_enemy_death():
	locked = false
	target = null

func _on_l_recovery_timeout() -> void:
	can_fire_left = true

func _on_r_recovery_timeout() -> void:
	can_fire_right = true

func _on_boost_timer_timeout():
	boosting = false
	can_boost = true

func _on_recoil_timer_timeout() -> void:
	can_move = true
	can_fire_left = true
	can_fire_right = true
