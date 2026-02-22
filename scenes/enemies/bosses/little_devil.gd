extends CharacterBody2D

var health = 3000
var speed = 500
var direction = Vector2.ZERO
var next_position
var distance_to_player
var backstep_point
var bullet_scene = preload("res://scenes/enemies/bullet.tscn")
var steel_bullet_directions = [-35, -28, -21, -14, -7, 0, 7, 14, 21, 28, 35]
var bullet_directions = [-15, -14, -13, -12, -11, -10, -9, -8, -7, -6, -5, -4, -3, -2, -1, 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15]
var bullet_wave_counter = 0
var damage_phase_damage = 0
var health_memory = health
var damage_phase_left = Vector2(225, 650)
var damage_phase_right = Vector2(2025, 650)
var damage_phase_point
var bullet_count = 40
var play_stagger_sound = true

@onready var nav: NavigationAgent2D = $NavigationAgent2D

func _ready():
	nav.target_position = global_position
	GlobalGlobal.enemies_room_count += 1

func _process(_delta):
	
	distance_to_player = global_position.distance_to(GlobalGlobal.player_position)
		
	next_position = nav.get_next_path_position()
	direction = (next_position - global_position).normalized()
	
	if $StaggerTimer.is_stopped():
		play_stagger_sound = true
		if global_position.distance_to(nav.target_position) <= 5:
			$AnimatedSprite2D.play("idle")
			velocity = Vector2.ZERO
		else:
			$AnimatedSprite2D.play("walk")
			velocity = direction * speed
		if not $DamagePhase.is_stopped():
			damage_phase_damage = 0
			$AttackTimer.wait_time = 0.1
			$DamagePhaseStop.start()
			if $MovementTimer.is_stopped():
				$MovementTimer.start()
				if randi_range(0,1) == 0:
					speed = 500
					move_toward_player()
				else:
					if distance_to_player > 1000:
						speed = 500
						move_toward_player()
					else:
						speed = 800
						backstep()
				
			if Input.is_action_just_released("attack") and distance_to_player < 300:
				$MovementTimer.start()
				speed = 800
				backstep()
			
			if $AttackTimer.is_stopped():
				$AttackTimer.start()
				var bullet = bullet_scene.instantiate()
				var point = GlobalGlobal.player_position - global_position
				bullet.angle = point.angle()
				bullet.global_position = global_position
				bullet.speed = 800
				bullet.bullet_type = "steel"
				get_tree().get_root().add_child(bullet)
				bullet.get_node("Timer").start()
			if $BulletShockwave.is_stopped():
				$BulletShockwave.start()
				for i in bullet_count:
					var angle = i * 360 / bullet_count
					var bullet = bullet_scene.instantiate()
					bullet.angle = angle
					bullet.position = position
					bullet.bullet_type = "steel"
					get_tree().get_root().add_child(bullet)
					bullet.get_node("Timer").start()
				
		elif $DamagePhase.is_stopped() and distance_to_player > 300 and damage_phase_damage < 300:
			$AttackTimer.wait_time = 0.4
			if damage_phase_left.distance_to(GlobalGlobal.player_position) > damage_phase_right.distance_to(GlobalGlobal.player_position):
				damage_phase_point = damage_phase_left
			else:
				damage_phase_point = damage_phase_right
			speed = 1500
			nav.target_position = damage_phase_point
			if $AttackTimer.is_stopped() and global_position.distance_to(damage_phase_point) <= 5:
				$AttackTimer.start()
				if bullet_wave_counter < 5:
					for i in steel_bullet_directions:
						var bullet = bullet_scene.instantiate()
						var point = GlobalGlobal.player_position - Vector2(global_position.x, global_position.y - 30)
						bullet.angle = point.angle() + deg_to_rad(i)
						bullet.global_position = global_position
						bullet.bullet_type = "steel"
						get_tree().get_root().add_child(bullet)
						bullet.get_node("Timer").start()
					bullet_wave_counter += 1
				else:
					for i in bullet_directions:
						var bullet = bullet_scene.instantiate()
						var point = GlobalGlobal.player_position - Vector2(global_position.x, global_position.y - 30)
						bullet.angle = point.angle() + deg_to_rad(i)
						bullet.global_position = global_position
						get_tree().get_root().add_child(bullet)
						bullet.get_node("Timer").start()
					bullet_wave_counter = 0
		else:
			$DamagePhase.start()
			if damage_phase_damage >= 300:
				$StaggerTimer.start()
			damage_phase_damage = 0
			
	else:
		velocity = Vector2.ZERO
		$AnimatedSprite2D.play("stagger")
		if play_stagger_sound:
			$StaggerSound.play()
			play_stagger_sound = false
		damage_phase_damage = 0
	
	move_and_slide()
	if $DamagePhaseStop.is_stopped() and $DamagePhase.is_stopped():
		$DamagePhase.start()
	
	if health <= 0:
		GlobalGlobal.enemies_room_count -= 1
		MusicMusic.boss_defeat_sound_player.play()
		MusicMusic.music_player.stop()
		GlobalGlobal.boss = false
		queue_free()
		
	if health != health_memory:
		damage_phase_damage += health_memory - health
		health_memory = health

func _on_area_2d_body_entered(body):
	if GlobalGlobal.dashing == false:
		if body.get_node_or_null("IFrames"):
			if body.get_node_or_null("IFrames").is_stopped():
				GlobalGlobal.current_health -= 1
				body.get_node_or_null("IFrames").start()
				
func _on_de_modulate_timeout():
	modulate = Color.WHITE
				
func move_toward_player():
	nav.target_position = GlobalGlobal.player_position
func backstep():
	var backstep_point_direction = (GlobalGlobal.player_position - global_position).normalized()
	backstep_point = global_position - backstep_point_direction * 300
	if line_of_sight(backstep_point):
		nav.target_position = backstep_point
	
func line_of_sight(pos) -> bool:
	var space_state = get_world_2d().direct_space_state
	var params = PhysicsRayQueryParameters2D.new()
	params.from = global_position
	params.to = pos
	params.exclude = []
	params.collision_mask = 1
	var result = space_state.intersect_ray(params)
	if result:
		return false
	return true
	
