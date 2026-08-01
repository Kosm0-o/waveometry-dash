extends Control

var infos : Array
var tweening : bool = false
var current_info : Panel

func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	global.trans_rect = $trans/ColorRect
	global.main_level = true
	global.fade_tween(false)
	infos = $main.get_children()
	current_info = infos.front()
	var p = global.progress["time_leaper"]
	$main/levelinfo/ProgressBar/percentage.text = str(int(p)) + "%"
	$main/levelinfo/ProgressBar.value = p
	$main/levelinfo2/ProgressBar/percentage.text = str(int(p)) + "%"
	$main/levelinfo2/ProgressBar.value = p
	for btn in $arrows.get_children():
		if btn is Button:
			btn.mouse_entered.connect(
				func():
					btn.modulate *= 1.3
			)
			btn.mouse_exited.connect(
				func():
					btn.modulate = Color("#dedede") if "left" in btn.name or "right" in btn.name else Color.WHITE
			)
	$arrows/left.pressed.connect(arrow_tween)
	$arrows/right.pressed.connect(arrow_tween.bind(-1))

func _process(delta: float) -> void:
	for panel in infos:
		var btn : Button = panel.get_node("Button")
		if btn.is_hovered():
			panel.self_modulate = Color.WHITE
		else:
			panel.self_modulate = Color.WHITE * 1.2

func _on_back_pressed() -> void:
	await global.fade_tween(true)
	get_tree().change_scene_to_file("res://scenes/mainmenu.tscn")

func arrow_tween(dir : int = 1):
	if tweening: return
	tweening = true
	var next_info = infos[1]
	var tween = create_tween()
	next_info.position.x = -1009.0 if dir == -1 else 1323.0
	tween.tween_property(current_info, "position:x", current_info.position.x + (82 * dir), 0.3).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_IN)
	tween.tween_property(current_info, "position:x", current_info.position.x - (1161 * dir), 0.8).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
	tween.parallel().tween_property(next_info, "position:x", next_info.position.x - (1161 * dir), 0.8).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
	await tween.finished
	current_info.position.x = 1323.0
	infos.append(infos.pop_front())
	current_info = infos.front()
	tweening = false


func _on_time_leaper_button_pressed() -> void:
	global.main_level_id = "time_leaper"
	EditorGlobal.current_lvl = "res://Resources/mainlevels/timeleaper.json"
	await global.fade_tween(true)
	get_tree().change_scene_to_file("res://scenes/game.tscn")
