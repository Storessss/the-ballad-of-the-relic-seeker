extends Node

var music_player
var deflect_sound_player
var enemy_defeat_sound_player
var boss_defeat_sound_player
var choir_sound_player

func _ready():
	music_player = AudioStreamPlayer2D.new()
	music_player.stream = preload("res://music/menu_music.mp3")
	music_player.bus = "Music"
	music_player.process_mode = Node.PROCESS_MODE_ALWAYS
	add_child(music_player)
	music_player.play()
	
	deflect_sound_player = AudioStreamPlayer2D.new()
	deflect_sound_player.stream = preload("res://sounds/melee_deflect.wav")
	deflect_sound_player.bus = "Sounds"
	add_child(deflect_sound_player)
	
	enemy_defeat_sound_player = AudioStreamPlayer2D.new()
	enemy_defeat_sound_player.stream = preload("res://sounds/enemy_death.wav")
	enemy_defeat_sound_player.bus = "Sounds"
	add_child(enemy_defeat_sound_player)
	
	boss_defeat_sound_player = AudioStreamPlayer2D.new()
	boss_defeat_sound_player.stream = preload("res://sounds/boss_defeat.mp3")
	boss_defeat_sound_player.bus = "Sounds"
	add_child(boss_defeat_sound_player)
	
	choir_sound_player = AudioStreamPlayer2D.new()
	choir_sound_player.stream = preload("res://sounds/choir.wav")
	choir_sound_player.bus = "Sounds"
	add_child(choir_sound_player)
	
func change_music():
	if GlobalGlobal.show_hud:
		music_player.stream = preload("res://music/music.mp3")
	else:
		music_player.stream = preload("res://music/menu_music.mp3")
	music_player.play()
