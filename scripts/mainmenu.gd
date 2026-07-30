extends Control

var cur_player : Player = null
var safe_timer : float = 0.0
var fading : bool = false

func _ready() -> void:
	RenderingServer.set_default_clear_color(Color.BLACK)
	EditorGlobal.editing = false
	randomize()
	for btn in $foregroundui.get_children():
		if btn is Button:
			btn.mouse_entered.connect(
				func():
					btn.modulate *= 1.3
			)
			btn.mouse_exited.connect(
				func():
					btn.modulate = Color.WHITE
			)
	global.trans_rect = $trans/ColorRect
	global.fade_tween(false)
	spawn_player()

func _process(delta: float) -> void:
	if cur_player != null and not fading:
		if cur_player.global_position.x > $playerback/playerstuff/endx.global_position.x:
			next_player()
		if cur_player.global_position.y < 48 or cur_player.global_position.y > 600:
			safe_timer += delta
			if safe_timer >= 0.25:
				cur_player.dir *= -1
				safe_timer = 0.0
	for bg in $background/bgsloop.get_children():
		bg.position.x -= 0.5
		if bg.position.x <= -1163.0:
			bg.position.x = 1141.0

func spawn_player():
	var new_player = preload("res://scenes/player.tscn").instantiate()
	new_player.auto = true
	new_player.angle = [63.425, 45, 15].pick_random()
	new_player.dir = [-1,0,1].pick_random()
	new_player.speedmod = [0.8, 1.0, 1.45, 1.8, 2.19].pick_random()
	$playerback/playerstuff.add_child(new_player)
	new_player.modulate = Color(randf(),randf(),randf())
	new_player.global_position = $playerback/playerstuff/startpos.global_position
	cur_player = new_player
	var new_trail = preload("res://scenes/trail.tscn").instantiate()
	new_trail.player = new_player
	$playerback/other.add_child(new_trail)
	new_trail.modulate = Color(randf(),randf(),randf())
	new_trail.set_starter_frames(5000)
	

func _on_quitbtn_pressed() -> void:
	await global.fade_tween(true)
	get_tree().quit()


func _on_playbtn_pressed() -> void:
	await global.fade_tween(true)
	get_tree().change_scene_to_file("res://scenes/levelselect.tscn")


func _on_settingsbtn_pressed() -> void:
	$foregroundui/settingsui/settingspanel.show()


func _on_editorbtn_pressed() -> void:
	await global.fade_tween(true)
	get_tree().change_scene_to_file("res://scenes/editorlevelmenu.tscn")

func trail_fade():
	fading = true
	var tween = create_tween().set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
	tween.tween_property(cur_player.trail_node, "modulate:a", 0.0, 0.5)
	await tween.finished
	fading = false

func next_player():
	await trail_fade()
	cur_player.trail_node.queue_free()
	cur_player.queue_free()
	cur_player = null
	spawn_player()


func _on_bgcolortimer_timeout() -> void:
	var tween = create_tween().set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
	var colors : Array[Color] = [
		Color.BLUE,
		Color.RED,
		Color.ORANGE,
		Color.YELLOW,
		Color.GREEN,
		Color.BLUE,
		Color.TURQUOISE,
		Color.INDIGO,
		Color.VIOLET,
		Color.MAGENTA,
		Color.ORANGE_RED,
		Color.SKY_BLUE,
		Color.DARK_BLUE,
		Color.DARK_ORANGE
	]
	colors.shuffle()
	tween.tween_property($background/bgsloop, "modulate", colors.pick_random(), 1.0)
