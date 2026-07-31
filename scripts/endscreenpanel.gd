extends Control

func _ready() -> void:
	for btn in [
		$replaybutton,
		$menubutton
	]:
		btn.mouse_entered.connect(highlight.bind(btn, true))
		btn.mouse_exited.connect(highlight.bind(btn, false))
		
func _on_menubutton_pressed() -> void:
	global.practice_mode = false
	get_tree().change_scene_to_packed(load("res://scenes/mainmenu.tscn"))


func _on_replaybutton_pressed() -> void:
	global.practice_mode = false
	get_tree().change_scene_to_packed(load("res://scenes/game.tscn"))
	

func highlight(node : Node, entered : bool):
	node.modulate = Color.WHITE if not entered else Color.WHITE * 1.3


func _on_attempts_visibility_changed() -> void:
	$Stats/attempts.text = "Attempts: " + str(global.attempts)
	var mins = int(global.time_passed / 60.0)
	var secs = int(global.time_passed - (mins * 60.0))
	var e = ":" if secs >= 10 else ":0"
	var c = "0" if mins < 10 else ""
	$Stats/time.text = "Time: " + c + str(mins) + e + str(secs)
