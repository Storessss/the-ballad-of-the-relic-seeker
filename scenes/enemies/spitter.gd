extends CharacterBody2D

var health = 80
var speed = 300
var direction = Vector2.ZERO
var next_position
var distance_to_player
var safe_distance = 450
var attack_range = 800
var move_range = 450
var bullet_scene = preload("res://scenes/enemies/bullet.tscn")
var spotted = false
var last_seen_position = Vector2.ZERO
var wandering = 125
var wandering_counter = 0
var distance_to_last_seen
var wandering_point

@onready var nav: NavigationAgent2D = $NavigationAgent2D

func _ready():
	nav.target_position = global_position
	GlobalGlobal.enemies_room_count += 1

func _process(_delta):
	if $MovementTimer.is_stopped():
		$MovementTimer.start()
		if spotted:
			$Emotion.play("alert")
			nav.target_position = last_seen_position
		else:
			wandering_counter += randi_range(0,3)
			if wandering_counter >= 5:
				wandering_point = Vector2(randi_range(global_position.x - wandering, global_position.x + wandering), 
				randi_range(global_position.y - wandering,global_position.y + wandering))
				if line_of_sight(wandering_point):
					nav.target_position = wandering_point
				wandering_counter = 0
		
	distance_to_player = global_position.distance_to(GlobalGlobal.player_position)
	distance_to_last_seen = global_position.distance_to(last_seen_position)
	
	next_position = nav.get_next_path_position()
	direction = (next_position - global_position).normalized()
	
	if distance_to_player < safe_distance and line_of_bullet_sight():
		safe_distance = attack_range
		direction = Vector2.ZERO
		if $AttackTimer.is_stopped():
			var bullet = bullet_scene.instantiate()
			var point = GlobalGlobal.player_position - global_position
			bullet.angle = point.angle()
			bullet.global_position = global_position
			get_tree().get_root().add_child(bullet)
			bullet.get_node("Timer").start()
			$AttackTimer.start()
			$AnimationTimer.start()
		if $AnimationTimer.is_stopped():
			$AnimatedSprite2D.play("idle")
		else:
			$AnimatedSprite2D.play("attack")
	else:
		safe_distance = move_range
		$AnimatedSprite2D.play("walk")
		$AttackTimer.start()
		
	if line_of_sight(GlobalGlobal.player_position):
		spotted = true
		last_seen_position = GlobalGlobal.player_position
		
	if wandering_point != null:
		if global_position.distance_to(wandering_point) <= 1 and not spotted:
			velocity = Vector2.ZERO
		else:
			velocity = direction * speed
	else:
		velocity = direction * speed
		
	if distance_to_last_seen <= 5:
		spotted = false
		$Emotion.play("confused")
		
	move_and_slide()
	
	if health <= 0:
		GlobalGlobal.enemies_room_count -= 1
		MusicMusic.enemy_defeat_sound_player.play()
		queue_free()
		

func _on_area_2d_body_entered(body):
	if GlobalGlobal.dashing == false:
		if body.get_node_or_null("IFrames"):
			if body.get_node_or_null("IFrames").is_stopped():
				GlobalGlobal.current_health -= 1
				body.get_node_or_null("IFrames").start()

func _on_de_modulate_timeout():
	modulate = Color.WHITE
	
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
	
func line_of_bullet_sight() -> bool:
	var space_state = get_world_2d().direct_space_state
	var params = PhysicsShapeQueryParameters2D.new()
	var shape = CircleShape2D.new()
	shape.radius = 15
	params.shape_rid = shape.get_rid()
	params.transform = Transform2D(0,global_position)
	params.motion = GlobalGlobal.player_position - global_position
	params.collision_mask = 1
	params.exclude = [self]
	var result = space_state.intersect_shape(params)
	if result.size() > 0:
		return false
	return true
