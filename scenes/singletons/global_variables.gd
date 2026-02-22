extends Node

var player_position = Vector2.ZERO
var max_health = 5
var current_health = 5
var health_memory = current_health

var dashing = false

var enemies_room_count = 0

var room = 0
var boss = false
var potion_timer

var can_move = true

var controller = false

var modulate_weapon = false

var show_hud = false

var master_volume = 0
var music_volume = 0
var sound_volume = 0
var screen_shake = true

var paused = false

var hide_room_title = false

var debug_enabled = false

var potion_progress = 0

var bullets = []

var can_grab_focus = true

func _process(_delta):
	if current_health <= 0:
		GlobalGlobal.boss = false
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		enemies_room_count = 0
		potion_progress = 0
		room = 0
		show_hud = false
		HudHud.update_health()
		MusicMusic.change_music()
		GlobalGlobal.current_health = max_health
		get_tree().change_scene_to_file("res://scenes/game/main_menu.tscn")
	Dialogic.VAR.health = current_health
	
	if boss:
		if potion_timer.is_stopped():
			potion_timer.start()
			potion_progress += 1
	
func _ready():
	Dialogic.signal_event.connect(dialogic_signal)
	potion_timer = Timer.new()
	potion_timer.wait_time = 10
	potion_timer.one_shot = true
	add_child(potion_timer)

func dialogic_signal(argument):
	if argument == "heal":
		current_health = max_health
		MusicMusic.choir_sound_player.play()
