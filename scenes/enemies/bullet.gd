extends Node2D

var direction
var speed = 600
var angle
var deflected = false

var particles_scene = preload("res://scenes/particles/enemy_hit_particles.tscn")

var bullet_type = "normal"

func _ready():
	if bullet_type == "normal":
		$Sprite2D.texture = load("res://sprites/bullet.png")
	elif bullet_type == "steel":
		$Sprite2D.texture = load("res://sprites/steel_bullet.png")
	GlobalGlobal.bullets.append(self)

func _process(delta):
	direction = Vector2(cos(angle), sin(angle))
	position += direction * speed * delta

func _on_timer_timeout():
	GlobalGlobal.bullets.erase(self)
	queue_free()

func _on_area_2d_body_entered(body):
	if !(body is TileMap):
		if GlobalGlobal.dashing == false and not deflected:
			if body.get_node_or_null("IFrames"):
				if body.get_node_or_null("IFrames").is_stopped():
					GlobalGlobal.current_health -= 1
					body.get_node_or_null("IFrames").start()
					
	GlobalGlobal.bullets.erase(self)
	queue_free()
	
func deflect():
	if not deflected and bullet_type != "steel":
		deflected = true
		$Sprite2D.texture = load("res://sprites/friendly_bullet.png")
		angle = angle - PI
		speed = 800
		MusicMusic.deflect_sound_player.play()
		
func _on_area_2d_area_entered(area):
	if deflected:
		if area.get_parent().get_node_or_null("NavigationAgent2D") or area.get_parent().get_node_or_null("DeModulate"):
			var body = area.get_parent()
			body.health -= 50
			body.modulate = Color.RED
			body.get_node_or_null("DeModulate").start()
			
			var particles = particles_scene.instantiate()
			particles.global_position = body.global_position
			particles.follow = body
			get_tree().get_root().add_child(particles)
			
			GlobalGlobal.bullets.erase(self)
			queue_free()
