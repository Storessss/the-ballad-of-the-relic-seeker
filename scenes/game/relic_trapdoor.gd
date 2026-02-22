extends Node2D

var can_open = false

func _process(_delta):
	if GlobalGlobal.enemies_room_count == 0 and not can_open:
		$OpeningTimer.start()
		can_open = true
	
	if can_open and $OpeningTimer.is_stopped() and $AnimatedSprite2D.animation == "closed":
		$AnimatedSprite2D.play("half_open")
		$OpenTimer.start()
		$OpeningSound.play()
		
func _on_area_2d_body_entered(body):
	for bullet in GlobalGlobal.bullets.duplicate():
		bullet.queue_free()
		GlobalGlobal.bullets.erase(bullet)
	GlobalGlobal.boss = false
	RoomRoom.call_deferred("change_room")

func _on_open_timer_timeout():
	$Area2D/CollisionShape2D.disabled = false
	$AnimatedSprite2D.play("open")
	get_parent().shake = true
	$OpenSound.play()
