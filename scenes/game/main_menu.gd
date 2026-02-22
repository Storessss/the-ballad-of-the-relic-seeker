extends Control

var settings_scene = preload("res://scenes/game/settings.tscn")

func _ready():
	GlobalGlobal.controller = false
	$Start.grab_focus()
	
func _process(_delta):
	if GlobalGlobal.can_grab_focus:
		$Start.grab_focus()
		GlobalGlobal.can_grab_focus = false

func _on_start_pressed():
	GlobalGlobal.room = 0
	GlobalGlobal.show_hud = true
	HudHud.update_health()
	MusicMusic.change_music()
	RoomRoom.change_room()

func _on_settings_pressed():
	var settings = settings_scene.instantiate()
	add_child(settings)
	
func _on_credits_pressed():
	$CreditsTextBox.visible = not $CreditsTextBox.visible
	
#func _on_quit_pressed():
	#get_tree().quit()

func _on_controls_pressed():
	$ControlsInfo.visible = not $ControlsInfo.visible
