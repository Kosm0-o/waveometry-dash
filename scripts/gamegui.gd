extends CanvasLayer

@onready var practice_mode_btn: TextureButton = $PauseMenu/Buttons/HboxContainer/PracticeModeBtn
@onready var menu_btn: TextureButton = $PauseMenu/Buttons/HboxContainer/MenuBtn
@onready var restart_btn: TextureButton = $PauseMenu/Buttons/HboxContainer/RestartBtn
@onready var play_btn: TextureButton = $PauseMenu/Buttons/PlayBtn


func _ready() -> void:
	global.trans_rect = $"../trans/ColorRect"
	$PauseMenu/musicslidernode/slider/musicslider.value = AudioServer.get_bus_volume_db(AudioServer.get_bus_index("Music"))
	$PauseMenu/musicslidernode/slider/sliderfill.value = $PauseMenu/musicslidernode/slider/musicslider.value
	$PauseMenu/sfxslidernode/slider/sfxslider.value = AudioServer.get_bus_volume_db(AudioServer.get_bus_index("SFX"))
	$PauseMenu/sfxslidernode/slider/sliderfill.value = $PauseMenu/sfxslidernode/slider/sfxslider.value
	await global.fade_tween(false, 0.7)
	$PauseBtn.pressed.connect(_handle_pausing.bind(true))
	$PauseMenu/Buttons/PlayBtn.pressed.connect(_handle_pausing.bind(false))
	practice_mode_btn.mouse_entered.connect(_scale_tween.bind(practice_mode_btn, true))
	practice_mode_btn.mouse_exited.connect(_scale_tween.bind(practice_mode_btn, false))
	menu_btn.mouse_entered.connect(_scale_tween.bind(menu_btn, true))
	menu_btn.mouse_exited.connect(_scale_tween.bind(menu_btn, false))
	restart_btn.mouse_entered.connect(_scale_tween.bind(restart_btn, true))
	restart_btn.mouse_exited.connect(_scale_tween.bind(restart_btn, false))
	play_btn.mouse_entered.connect(_scale_tween.bind(play_btn, true))
	play_btn.mouse_exited.connect(_scale_tween.bind(play_btn, false))
	$PauseMenu/musicslidernode/slider/musicslider.mouse_entered.connect(highlight.bind($PauseMenu/musicslidernode/slider, true))
	$PauseMenu/musicslidernode/slider/musicslider.mouse_exited.connect(highlight.bind($PauseMenu/musicslidernode/slider, false))
	$PauseMenu/sfxslidernode/slider/sfxslider.mouse_entered.connect(highlight.bind($PauseMenu/sfxslidernode/slider, true))
	$PauseMenu/sfxslidernode/slider/sfxslider.mouse_exited.connect(highlight.bind($PauseMenu/sfxslidernode/slider, false))

func _process(delta: float) -> void:
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Music"), $PauseMenu/musicslidernode/slider/musicslider.value)
	$PauseMenu/musicslidernode/slider/sliderfill.value = $PauseMenu/musicslidernode/slider/musicslider.value
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("SFX"), $PauseMenu/sfxslidernode/slider/sfxslider.value)
	$PauseMenu/sfxslidernode/slider/sliderfill.value = $PauseMenu/sfxslidernode/slider/sfxslider.value

func _on_practice_mode_btn_toggled(toggled_on: bool) -> void:
	_handle_pausing(false)
	if not toggled_on:
		for c in get_tree().get_nodes_in_group("checkpoint"):
			global.all_checkpoints.erase(c)
			c.queue_free()
		global.players.front().die()
	else:
		global.players.front().place_checkpoint()
	global.practice_mode = toggled_on

func _on_menu_btn_pressed() -> void:
	await global.fade_tween(true)
	global.players.front().trail_node.queue_free()
	global.players.front().queue_free()
	global.practice_mode = false
	get_tree().paused = false
	get_tree().change_scene_to_packed(load("res://scenes/mainmenu.tscn"))

func _on_restart_btn_pressed() -> void:
	_handle_pausing(false)
	global.players.front().die()


func _handle_pausing(paused : bool):
	$PauseBtn.release_focus()
	get_tree().paused = paused
	$PauseBtn.visible = not paused
	$PauseMenu.visible = paused

func _scale_tween(button, hover : bool):
	var m = 1.0 if not hover else 1.15
	var c = Color(1.15,1.15,1.15) if hover else Color.WHITE
	if button.name == $PauseMenu/Buttons/PlayBtn.name:
		m = 1.165 if not hover else 1.25
	var tween = create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CUBIC).set_parallel()
	tween.tween_property(button, "scale", Vector2.ONE * m, 0.2)
	tween.tween_property(button, "modulate", c, 0.2)
	await tween.finished

func highlight(node : Node, entered : bool):
	node.modulate = Color.WHITE if not entered else Color.WHITE * 1.3

func endscreen():
	$endscreenpanel.show()
