extends Node2D

var direction
var speed = 600
var damage

var deflective = false

var particles_scene = preload("res://scenes/particles/enemy_hit_particles.tscn")

func _process(delta):
	direction = Vector2(cos(rotation + PI / 2 + PI), sin(rotation + PI / 2 + PI))
	position += direction * speed * delta

func _on_timer_timeout():
	get_parent().remove_child(self)

func _on_area_2d_area_entered(area):
	if area.get_parent().get_node_or_null("IAmEnemyBullet"):
		#area.get_parent().get_parent().remove_child(area.get_parent())
		if deflective:
			area.get_parent().deflect()
	if area.get_parent().get_node_or_null("NavigationAgent2D") or area.get_parent().get_node_or_null("DeModulate"):
		var body = area.get_parent()
		body.health -= damage
		body.modulate = Color.RED
		body.get_node_or_null("DeModulate").start()
		
		var particles = particles_scene.instantiate()
		particles.global_position = body.global_position
		particles.follow = body
		get_tree().get_root().add_child(particles)

func _on_area_2d_body_entered(body):
	queue_free()
