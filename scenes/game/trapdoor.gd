extends Node2D

func _process(_delta):
	if GlobalGlobal.enemies_room_count == 0 and $AnimatedSprite2D.animation == "closed":
		$AnimatedSprite2D.play("half_open")
		$OpeningTimer.start()
		$OpeningSound.play()
		
func _on_area_2d_body_entered(body):
	GlobalGlobal.potion_progress += 1
	for bullet in GlobalGlobal.bullets.duplicate():
		bullet.queue_free()
		GlobalGlobal.bullets.erase(bullet)
	RoomRoom.call_deferred("change_room")

func _on_opening_timer_timeout():
	$Area2D/CollisionShape2D.disabled = false
	$AnimatedSprite2D.play("open")
	get_parent().shake = true
