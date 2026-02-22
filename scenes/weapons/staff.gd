extends Node2D

var orb_scene = preload("res://scenes/weapons/staff_orb.tscn")
var player
var forward
var back
var sprite = preload("res://sprites/staff.png")
var timer

func _ready():
	player = get_node("../../..")
	player.connect("ranged_attack", Callable(self, "_on_ranged_attack"))
	forward = get_node("../../../Forward/Weapon")
	back = get_node("../../../Back/Weapon")
	forward.texture = sprite
	back.texture = sprite
	timer = get_node("../../../SwitchWeapon")
	
func _on_ranged_attack(direction, location):
	if $Timer.is_stopped() and timer.is_stopped():
		$Timer.start()
		var orb = orb_scene.instantiate()
		orb.rotation = direction
		orb.position = location
		orb.damage = 15
		get_tree().get_root().add_child(orb)
		orb.get_node("Timer").start()
		$StaffShootSound.play()
		
func _process(_delta):
	forward.visible = true
	back.visible = false
