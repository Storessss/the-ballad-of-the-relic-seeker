extends Node

var halberd_scene = preload("res://scenes/weapons/halberd.tscn")
var staff_scene = preload("res://scenes/weapons/staff.tscn")
enum Weapons {
	HALBERD,
	STAFF
}
var inventory = [Weapons.HALBERD, Weapons.STAFF]
var selector = 0

func switch_weapon(next):
	if next == true:
		if selector == len(inventory) - 1:
			selector = 0
		else:
			selector += 1
	else:
		if selector == 0:
			selector = len(inventory) - 1
		else:
			selector -= 1
	return weapon_selector(next)

func weapon_selector(next):
	if inventory[selector] == Weapons.HALBERD:
		return halberd()
	elif inventory[selector] == Weapons.STAFF:
		return staff()
	else:
		return switch_weapon(next)

func halberd():
	var weapon = halberd_scene.instantiate()
	return weapon
func staff():
	var weapon = staff_scene.instantiate()
	return weapon
