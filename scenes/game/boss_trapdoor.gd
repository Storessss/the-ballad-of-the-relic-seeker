extends Node2D

func _process(_delta):
	if $OpeningTimer.is_stopped() and $AnimatedSprite2D.animation == "closed":
		$AnimatedSprite2D.play("half_open")
		$OpenTimer.start()
		$OpeningSound.play()
		
func _on_area_2d_body_entered(body):
	for bullet in GlobalGlobal.bullets.duplicate():
		bullet.queue_free()
		GlobalGlobal.bullets.erase(bullet)
	RoomRoom.call_deferred("change_room")

func _on_open_timer_timeout():
	$Area2D/CollisionShape2D.disabled = false
	$AnimatedSprite2D.play("open")
	get_parent().shake = true
	$OpenSound.play()
