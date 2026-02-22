extends Node

var enemy_number = 4

var slime_scene = preload("res://scenes/enemies/slime.tscn")
var spitter_scene = preload("res://scenes/enemies/spitter.tscn")
var crusher_scene = preload("res://scenes/enemies/crusher.tscn")
var triple_shooter_scene = preload("res://scenes/enemies/triple_shooter.tscn")

func enemy_spawner(i):
	if i == 1:
		return slime()
	elif i == 2:
		return spitter()
	elif i == 3:
		return crusher()
	elif i == 4:
		return triple_shooter()
		
func slime():
	var enemy = slime_scene.instantiate()
	enemy.global_position = GlobalGlobal.player_position
	add_child(enemy)
	
func spitter():
	var enemy = spitter_scene.instantiate()
	enemy.global_position = GlobalGlobal.player_position
	add_child(enemy)
	
func crusher():
	var enemy = crusher_scene.instantiate()
	enemy.global_position = GlobalGlobal.player_position
	add_child(enemy)
	
func triple_shooter():
	var enemy = triple_shooter_scene.instantiate()
	enemy.global_position = GlobalGlobal.player_position
	add_child(enemy)
