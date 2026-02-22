extends Node2D

var spitter_scene = preload("res://scenes/enemies/spitter.tscn")

func _on_timer_timeout():
	var spitter = spitter_scene.instantiate()
	add_child(spitter)
