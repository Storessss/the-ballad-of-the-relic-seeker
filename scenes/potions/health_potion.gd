extends Node2D

var drinking = false
var animation

func _process(_delta):
	if GlobalGlobal.show_hud:
		visible = true
	else:
		visible = false
	if GlobalGlobal.potion_progress <= 0:
		$AnimatedSprite2D.play("empty")
	elif GlobalGlobal.potion_progress == 1:
		$AnimatedSprite2D.play("one_fourth")
		if animation != $AnimatedSprite2D.animation:
			$RechargeSound.play()
	elif GlobalGlobal.potion_progress == 2:
		$AnimatedSprite2D.play("two_fourths")
		if animation != $AnimatedSprite2D.animation:
			$RechargeSound.play()
	elif GlobalGlobal.potion_progress == 3:
		$AnimatedSprite2D.play("three_fourths")
		if animation != $AnimatedSprite2D.animation:
			$RechargeSound.play()
	elif GlobalGlobal.potion_progress >= 4:
		$AnimatedSprite2D.play("full")
		if animation != $AnimatedSprite2D.animation:
			$FullyChargedSound.play()
	animation = $AnimatedSprite2D.animation
		
	if Input.is_action_pressed("potion") and $AnimatedSprite2D.animation == "full":
		if not drinking:
			drinking = true
			$DrinkTimer.start()
			$DrinkSound.play()
		GlobalGlobal.can_move = false
	if Input.is_action_just_released("potion"):
		if not $DrinkTimer.is_stopped():
			$DrinkSound.stop()
		drinking = false
		GlobalGlobal.can_move = true
	if $DrinkTimer.is_stopped() and drinking:
		drinking = false
		GlobalGlobal.potion_progress = 0
		GlobalGlobal.current_health += 2
