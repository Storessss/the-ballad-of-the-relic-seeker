extends Node2D

var can_interact = false
var can_quit = false

func _ready():
	$AnimationPlayer.play("artifact_float")
	MusicMusic.music_player.stop()

func _process(_delta):
	if can_interact and Input.is_action_just_pressed("interact") and $Relic.visible == true:
		$Relic.visible = false
		$RelicGet.play()
		$ItemGet.play()
		$WinTimer.start()
	if not $WinTimer.is_stopped():
		$Label.visible = true
	elif $WinTimer.is_stopped() and $Label.visible == true:
		$Label.visible = false
		$QuitTimer.start()
		can_quit = true
		
	if $QuitTimer.is_stopped() and can_quit:
		GlobalGlobal.boss = false
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		GlobalGlobal.potion_progress = 0
		GlobalGlobal.room = 0
		GlobalGlobal.enemies_room_count = 0
		GlobalGlobal.show_hud = false
		HudHud.update_health()
		MusicMusic.change_music()
		GlobalGlobal.current_health = GlobalGlobal.max_health
		get_tree().change_scene_to_file("res://scenes/game/main_menu.tscn")

func _on_area_2d_body_entered(body):
	can_interact = true

func _on_area_2d_body_exited(body):
	can_interact = false
