extends Node2D

var is_clear = false

var shake = false
var random_strength = 30.0
var shake_fade = 5.0
var rnd = RandomNumberGenerator.new()
var shake_strength = 0.0

func _ready():
	MusicMusic.music_player.stream = preload("res://music/little_devil's_theme.mp3")
	MusicMusic.music_player.play()
	GlobalGlobal.boss = true

func _process(delta):
	if GlobalGlobal.enemies_room_count == 0 and is_clear == false:
		is_clear = true
		
	if shake:
		apply_shake()
		shake = false
	if shake_strength > 0:
		shake_strength = lerpf(shake_strength, 0, shake_fade * delta)
	
	if GlobalGlobal.screen_shake:
		$Player/Camera2D.offset = randomOffset()
		
func apply_shake():
	shake_strength = random_strength
func randomOffset():
	return Vector2(rnd.randf_range(- shake_strength, shake_strength), randf_range(- shake_strength, shake_strength))
