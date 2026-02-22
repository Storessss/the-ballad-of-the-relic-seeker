extends CharacterBody2D

# used for movement
var move_speed = 600
var direction

# signal for slected weapon attack
signal melee_attack(direction, location)
signal ranged_attack(direction, location)
signal attack_release(direction, location)

# used for weapon management
var weapon
var weapon_to_remove

# used for angle of cursor
var cursor
var point
var angle

# used for dash mechanic
var dash_angle
var dash_speed = 5000

var deadzone = 0.1
var look_vector

func _ready():
	# select first weapon in inventory
	weapon = WeaponWeapon.weapon_selector(true)
	# add to node in charge of weapons
	$Forward/Weapon.add_child(weapon)
	
	InputMap.action_set_deadzone("aim_up", deadzone)
	InputMap.action_set_deadzone("aim_down", deadzone)
	InputMap.action_set_deadzone("aim_left", deadzone)
	InputMap.action_set_deadzone("aim_right", deadzone)
		

func _process(_delta):
	
	# so enemies can find player
	GlobalGlobal.player_position = position
	
	# movement
	if GlobalGlobal.can_move:
		direction = Input.get_vector("left", "right", "up", "down")
	else:
		direction = Vector2.ZERO
	
	if $DashTimer.is_stopped() and GlobalGlobal.dashing:
		$DashCooldown.start()
	# if not dashing
	if $DashTimer.is_stopped():
		velocity = direction * move_speed
		GlobalGlobal.dashing = false
	# if dashing
	else:
		velocity = dash_angle * dash_speed
	
	# movement
	move_and_slide()
	
	if not $IFrames.is_stopped():
		$AnimatedSprite2D.play("blink")
	# if moving
	elif direction!= Vector2(0,0):
		$AnimatedSprite2D.play("walk")
		$AnimationTimer.start()
	# if not moving
	else:
		if not $AnimationTimer.is_stopped():
			$AnimatedSprite2D.play("idle")
		else:
			if $AnimatedSprite2D.frame == 16:
				$AnimationTimer.wait_time = 100
				$AnimationTimer.start()
			else:
				$AnimatedSprite2D.play("shifting_eyes")
	# flip sprite based on movement direction
	if velocity.x != 0:
		$AnimatedSprite2D.flip_h = velocity.x < 0
		
	if !GlobalGlobal.controller:
		# get mouse pos
		cursor = get_global_mouse_position()
		# difference
		point = cursor - $Forward.global_position
		# angle compared to player
		angle = point.angle()
	else:
		look_vector = Vector2.ZERO
		look_vector.x = Input.get_action_strength("aim_right") - Input.get_action_strength("aim_left")
		look_vector.y = Input.get_action_strength("aim_down") - Input.get_action_strength("aim_up")
		$Reticle.global_position = (position + look_vector * 250)
		point = $Reticle.global_position - $Forward.global_position
		angle = point.angle()
	# rotation of weapon aiming forward
	$Forward.rotation = angle - PI / 2 + PI
	# rotation of weapon aiming backwards
	$Back.rotation = $Forward.rotation + PI
	
	# if attacking
	if Input.is_action_just_pressed("attack") and GlobalGlobal.can_move:
		# emit signal with angle and pos
		emit_signal("melee_attack", $Forward.global_rotation, Vector2($Forward/Weapon.global_position))
	if Input.is_action_pressed("attack") and GlobalGlobal.can_move:
		emit_signal("ranged_attack", $Forward.global_rotation, Vector2($Forward/Weapon.global_position))
	if Input.is_action_just_released("attack") and GlobalGlobal.can_move:
		emit_signal("attack_release", $Forward.global_rotation, Vector2($Forward/Weapon.global_position))
		
	# if next weapon
	if Input.is_action_just_pressed("next_weapon") and GlobalGlobal.can_move:
		# remove old one
		weapon_to_remove = get_node("Forward/Weapon/" + str(weapon))
		weapon_to_remove.queue_free()
		# get new one
		weapon = WeaponWeapon.switch_weapon(true)
		# add
		$Forward/Weapon.add_child(weapon)
		# timer to prevent switched weapon to shoot immediately
		$SwitchWeapon.start()
		
		$Forward.modulate = Color.WHITE
		$Back.modulate = Color.WHITE
	# if previous weapon
	elif Input.is_action_just_pressed("previous_weapon") and GlobalGlobal.can_move:
		# remove old one
		weapon_to_remove = get_node("Forward/Weapon/" + str(weapon))
		weapon_to_remove.queue_free()
		# get new one
		weapon = WeaponWeapon.switch_weapon(false)
		# add
		$Forward/Weapon.add_child(weapon)
		# timer to prevent switched weapon to shoot immediately
		$SwitchWeapon.start()
		
		$Forward.modulate = Color.WHITE
		$Back.modulate = Color.WHITE
		
	if $DashCooldown.is_stopped() and $DashTimer.is_stopped():
		modulate = Color.WHITE
	if Input.is_action_just_pressed("dash") and $DashCooldown.is_stopped() and GlobalGlobal.can_move:
		$DashSound.play()
		dash_angle = direction
		GlobalGlobal.dashing = true
		$DashTimer.start()
		modulate = Color.DIM_GRAY
		
	if Input.is_action_just_pressed("switch_input_method") and GlobalGlobal.can_move:
		GlobalGlobal.controller = not GlobalGlobal.controller
	if GlobalGlobal.controller:
		Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
		if look_vector == Vector2.ZERO:
			$Reticle.visible = false
		else:
			$Reticle.visible = true
	else:
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		$Reticle.visible = false
