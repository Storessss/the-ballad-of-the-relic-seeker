extends CharacterBody2D

var health = 200
var bullet_scene = preload("res://scenes/enemies/bullet.tscn")
var bullet_count = 40

func _ready():
	$AttackTimer.start()
	GlobalGlobal.enemies_room_count += 1

func _process(_delta):
	
	if $AttackTimer.is_stopped() and line_of_sight():
		$AttackTimer.wait_time = 2.5
		$AnimatedSprite2D.play("attack")
		
	if $AnimatedSprite2D.animation == "attack" and $AttackTimer.is_stopped():
		for i in bullet_count:
			var angle = i * 360 / bullet_count
			var bullet = bullet_scene.instantiate()
			bullet.angle = angle
			bullet.position = position
			get_tree().get_root().add_child(bullet)
			bullet.get_node("Timer").start()
		$AttackTimer.start()
		$CrushSound.play()
		
	if !$AttackTimer.is_stopped() and $AnimatedSprite2D.frame == 1:
		$AnimatedSprite2D.play("idle")
		
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
	
func line_of_sight() -> bool:
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
