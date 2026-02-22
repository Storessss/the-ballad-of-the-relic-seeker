extends Node2D

var melee_scene = preload("res://scenes/weapons/melee_swing.tscn")
var player
var forward
var back
var sprite = preload("res://sprites/halberd.png")
var timer
var charging = false

func _ready():
	player = get_node("../../..")
	player.connect("ranged_attack", Callable(self, "_on_melee_attack"))
	player.connect("attack_release", Callable(self, "_on_attack_release"))
	forward = get_node("../../../Forward/Weapon")
	back = get_node("../../../Back/Weapon")
	forward.texture = sprite
	back.texture = sprite
	timer = get_node("../../../SwitchWeapon")
	
func _on_melee_attack(direction, location):
	if not charging:
		$ChargeAttack.start()
	charging = true
	
func _on_attack_release(direction, location):
	charging = false
	if $Timer.is_stopped() and timer.is_stopped():
		$Timer.start()
		var melee = melee_scene.instantiate()
		melee.rotation = direction
		melee.position = location
		if forward.modulate == Color.RED:
			melee.deflective = true
			melee.damage = 80
			melee.modulate = Color.RED
			$ChargedSwipeSound.play()
		else:
			melee.damage = 40
			$SwipeSound.play()
		get_tree().get_root().add_child(melee)
		melee.get_node("Timer").start()
		
func _process(_delta):
	if $Timer.is_stopped():
		forward.visible = false
		back.visible = true
	else:
		forward.visible = true
		back.visible = false
	if $ChargeAttack.is_stopped() and charging:
		if forward.modulate == Color.WHITE:
			$ChargedSound.play()
		forward.modulate = Color.RED
		back.modulate = Color.RED
	else:
		forward.modulate = Color.WHITE
		back.modulate = Color.WHITE
	if Input.is_action_just_pressed("next_weapon") or Input.is_action_just_pressed("previous_weapon"):
		forward.modulate = Color.WHITE
		back.modulate = Color.WHITE
