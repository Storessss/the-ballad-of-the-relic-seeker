extends Node

var heart_full_sprite = preload("res://sprites/heart.png")
var heart_empty_sprite = preload("res://sprites/heart_hurt.png")
var heart_index_x = 30
var heart_index_y = 30
var heart_index_increment = 60

var hit_sound

var hud

var fps_counter

var console

var settings_scene = preload("res://scenes/game/settings.tscn")

var room_title

var yoster = preload("res://fonts/yoster.ttf")

var potion
var health_potion_scene = preload("res://scenes/potions/health_potion.tscn")

var advice_label

func _process(_delta):
	if GlobalGlobal.health_memory != GlobalGlobal.current_health:
		update_health()
		if GlobalGlobal.health_memory > GlobalGlobal.current_health:
			hit_sound.play()
		GlobalGlobal.health_memory = GlobalGlobal.current_health
	if GlobalGlobal.current_health > GlobalGlobal.max_health:
		GlobalGlobal.current_health = GlobalGlobal.max_health
		GlobalGlobal.health_memory = GlobalGlobal.current_health
		update_health()
		
	fps_counter.text = "FPS: " + str(Engine.get_frames_per_second())
	
	if Input.is_action_just_pressed("console") and GlobalGlobal.debug_enabled:
		GlobalGlobal.can_move = false
		console.visible = true
		console.grab_focus()
	elif Input.is_action_just_pressed("enter"):
		GlobalGlobal.can_move = true
		if console.text == "slime":
			EnemyEnemy.enemy_spawner(1)
		elif console.text == "spitter":
			EnemyEnemy.enemy_spawner(2)
		elif console.text == "crusher":
			EnemyEnemy.enemy_spawner(3)
		elif console.text == "triple":
			EnemyEnemy.enemy_spawner(4)
		elif console.text == "heal":
			GlobalGlobal.current_health += 1
		elif console.text == "damage":
			GlobalGlobal.current_health -= 1
		elif console.text == "potion":
			GlobalGlobal.potion_progress += 1
		elif console.text == "room1":
			GlobalGlobal.room = 0
			RoomRoom.change_room()
		elif console.text == "room2":
			GlobalGlobal.room = 1
			RoomRoom.change_room()
		elif console.text == "room3":
			GlobalGlobal.room = 2
			RoomRoom.change_room()
		elif console.text == "room4":
			GlobalGlobal.room = 3
			RoomRoom.change_room()
		elif console.text == "room5":
			GlobalGlobal.room = 4
			RoomRoom.change_room()
		elif console.text == "room6":
			GlobalGlobal.room = 5
			RoomRoom.change_room()
		elif console.text == "room7":
			GlobalGlobal.room = 6
			RoomRoom.change_room()
		elif console.text == "room8":
			GlobalGlobal.room = 7
			RoomRoom.change_room()
		elif console.text == "room9":
			GlobalGlobal.room = 8
			RoomRoom.change_room()
		elif console.text == "room10":
			GlobalGlobal.room = 9
			RoomRoom.change_room()
		elif console.text == "room11":
			GlobalGlobal.room = 10
			RoomRoom.change_room()
		elif console.text == "room12":
			GlobalGlobal.room = 11
			RoomRoom.change_room()
		elif console.text == "room13":
			GlobalGlobal.room = 12
			RoomRoom.change_room()
		elif console.text == "room14":
			GlobalGlobal.room = 13
			RoomRoom.change_room()
		elif console.text == "room15":
			GlobalGlobal.room = 14
			RoomRoom.change_room()
		elif console.text == "room16":
			GlobalGlobal.room = 15
			RoomRoom.change_room()
		console.text = ""
		console.release_focus()
		console.visible = false
		
	if Input.is_action_just_pressed("pause"):
		GlobalGlobal.paused = not GlobalGlobal.paused
		if GlobalGlobal.paused:
			var settings = settings_scene.instantiate()
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
			settings.get_node_or_null("Quit").disabled = false
			settings.get_node_or_null("Quit").visible = true
			settings.get_node_or_null("Controls").disabled = false
			settings.get_node_or_null("Controls").visible = true
			hud.add_child(settings)
			
	if GlobalGlobal.hide_room_title or not GlobalGlobal.show_hud:
		room_title.visible = false
	else:
		room_title.visible = true
		
	if GlobalGlobal.room == 0:
		room_title.text = ""
	elif GlobalGlobal.room == 1:
		room_title.text = "The Beginning"
	elif GlobalGlobal.room == 2:
		room_title.text = "Sandwiched"
	elif GlobalGlobal.room == 3:
		room_title.text = "Corridors"
	elif GlobalGlobal.room == 4:
		room_title.text = "Surrounded"
	elif GlobalGlobal.room == 5:
		room_title.text = "New Friend"
	elif GlobalGlobal.room == 6:
		room_title.text = "Spitter Party"
	elif GlobalGlobal.room == 7:
		room_title.text = "Two Team Attack"
	elif GlobalGlobal.room == 8:
		room_title.text = "Rommates"
	elif GlobalGlobal.room == 9:
		room_title.text = "New... Friend?"
	elif GlobalGlobal.room == 10:
		room_title.text = "Fireworks"
	elif GlobalGlobal.room == 11:
		room_title.text = "Not invited."
	elif GlobalGlobal.room == 12:
		room_title.text = "Don't get distracted!"
	elif GlobalGlobal.room == 13:
		room_title.text = "The great slime army"
	elif GlobalGlobal.room == 14:
		room_title.text = "Trenches"
	elif GlobalGlobal.room == 15:
		room_title.text = "Target practice"
	elif GlobalGlobal.room == 16:
		room_title.text = "All together now!"
	elif GlobalGlobal.room == 17:
		room_title.text = ""
	elif GlobalGlobal.room == 18:
		room_title.text = ""
	elif GlobalGlobal.room == 19:
		room_title.text = ""
		
	if GlobalGlobal.room == 3:
		advice_label.text = "Hold and release attack for a charged hit"
	elif GlobalGlobal.room == 6:
		advice_label.text = "Charged attacks can deflect red bullets"
	else:
		advice_label.text = ""
		
	
func _ready():
	hud = CanvasLayer.new()
	add_child(hud)
	
	var cursor_texture = preload("res://sprites/crosshair.png")
	var cursor_width = cursor_texture.get_width()
	var cursor_height = cursor_texture.get_height()
	var hotspot = Vector2(cursor_width / 2, cursor_height / 2)
	Input.set_custom_mouse_cursor(cursor_texture, Input.CURSOR_ARROW, hotspot)
	
	hit_sound = AudioStreamPlayer2D.new()
	hit_sound.stream = preload("res://sounds/hit.wav")
	add_child(hit_sound)
	
	fps_counter = Label.new()
	fps_counter.position.x = 1850
	fps_counter.position.y = 5
	hud.add_child(fps_counter)
	
	update_health()
	
	console = LineEdit.new()
	console.size.x = 500
	console.position.x = 685
	hud.add_child(console)
	console.visible = false
	
	room_title = Label.new()
	room_title.add_theme_font_override("font", yoster)
	room_title.add_theme_color_override("font_color", Color.WHITE)
	room_title.add_theme_font_size_override("font_size", 100)
	room_title.scale.x = 0.38
	room_title.scale.y = 0.38
	room_title.position = Vector2(0, 1035)
	hud.add_child(room_title)
	
	potion = health_potion_scene.instantiate()
	potion.position = Vector2(1880, 70)
	hud.add_child(potion)
	
	advice_label = Label.new()
	advice_label.add_theme_font_override("font", yoster)
	advice_label.add_theme_color_override("font_color", Color.WHITE)
	advice_label.add_theme_font_size_override("font_size", 70)
	advice_label.scale.x = 0.38
	advice_label.scale.y = 0.38
	advice_label.position = Vector2(1200, 1050)
	hud.add_child(advice_label)

func update_health():
	for child in hud.get_children():
		if child is Sprite2D:
			child.queue_free()
	if GlobalGlobal.show_hud:
		for i in range(GlobalGlobal.current_health):
			var heart = Sprite2D.new()
			heart.texture = heart_full_sprite
			heart.position = Vector2(heart_index_x, heart_index_y)
			heart_index_x += heart_index_increment
			hud.add_child(heart)
		for i in range(GlobalGlobal.max_health - GlobalGlobal.current_health):
			var heart = Sprite2D.new()
			heart.texture = heart_empty_sprite
			heart.position = Vector2(heart_index_x, heart_index_y)
			heart_index_x += heart_index_increment
			hud.add_child(heart)
		heart_index_x = 30
