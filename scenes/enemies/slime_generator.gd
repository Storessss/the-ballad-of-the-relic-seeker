extends Node2D

var slime_scene = preload("res://scenes/enemies/slime.tscn")

func _on_timer_timeout():
	var slime = slime_scene.instantiate()
	add_child(slime)
