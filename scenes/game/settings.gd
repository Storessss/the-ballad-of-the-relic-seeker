extends Control

func _ready():
	GlobalGlobal.hide_room_title = true
	get_tree().paused = true
	$Master.value = GlobalGlobal.master_volume
	$Music.value = GlobalGlobal.music_volume
	$Sounds.value = GlobalGlobal.sound_volume
	$ScreenShake.button_pressed = GlobalGlobal.screen_shake
	$Back.grab_focus()

func _on_master_value_changed(value):
	AudioServer.set_bus_volume_db(0,value)
	$TestSound.play()
	GlobalGlobal.master_volume = value
	
func _on_music_value_changed(value):
	AudioServer.set_bus_volume_db(1,value)
	GlobalGlobal.music_volume = value
	
func _on_sounds_value_changed(value):
	AudioServer.set_bus_volume_db(2,value)
	$TestSound.play()
	GlobalGlobal.sound_volume = value

func _on_back_pressed():
	GlobalGlobal.hide_room_title = false
	get_tree().paused = false
	if GlobalGlobal.controller:
		Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
	GlobalGlobal.can_grab_focus = true
	queue_free()
	
func _on_screen_shake_toggled(toggled_on):
	GlobalGlobal.screen_shake = toggled_on

func _on_quit_pressed():
	GlobalGlobal.boss = false
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	GlobalGlobal.potion_progress = 0
	GlobalGlobal.room = 0
	GlobalGlobal.enemies_room_count = 0
	GlobalGlobal.show_hud = false
	HudHud.update_health()
	MusicMusic.change_music()
	GlobalGlobal.current_health = GlobalGlobal.max_health
	$Quit.visible = false
	$Quit.disabled = true
	$Controls.visible = false
	$Controls.disabled = true
	get_tree().paused = false
	get_tree().change_scene_to_file("res://scenes/game/main_menu.tscn")
	queue_free()
	
func _on_controls_pressed():
	$ControlsInfo.visible = not $ControlsInfo.visible
