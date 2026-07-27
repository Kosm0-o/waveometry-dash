extends Control

func _ready() -> void:
	global.trans_rect = $trans/ColorRect
	global.fade_tween(false)



func _on_back_pressed() -> void:
	await global.fade_tween(true)
	get_tree().change_scene_to_file("res://scenes/mainmenu.tscn")
