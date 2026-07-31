extends Control

func _ready() -> void:
	$X.mouse_entered.connect(highlight.bind($X, true))
	$X.mouse_exited.connect(highlight.bind($X, false))
	$controlspanel/X.mouse_entered.connect(highlight.bind($controlspanel/X, true))
	$controlspanel/X.mouse_exited.connect(highlight.bind($controlspanel/X, false))
	$tutorial.mouse_entered.connect(highlight.bind($tutorial, true))
	$tutorial.mouse_exited.connect(highlight.bind($tutorial, false))
	$settingspanel/org/filler/musicslider.mouse_entered.connect(highlight.bind($settingspanel/org/filler, true))
	$settingspanel/org/filler/musicslider.mouse_exited.connect(highlight.bind($settingspanel/org/filler, false))
	$settingspanel/org/filler2/sfxslider.mouse_entered.connect(highlight.bind($settingspanel/org/filler2, true))
	$settingspanel/org/filler2/sfxslider.mouse_exited.connect(highlight.bind($settingspanel/org/filler2, false))
	$settingspanel/org/filler/musicslider.value = AudioServer.get_bus_volume_db(AudioServer.get_bus_index("Music"))
	$settingspanel/org/filler/sliderfill.value = $settingspanel/org/filler/musicslider.value
	$settingspanel/org/filler2/sfxslider.value = AudioServer.get_bus_volume_db(AudioServer.get_bus_index("Music"))
	$settingspanel/org/filler2/sliderfill.value = $settingspanel/org/filler2/sfxslider.value
	$settingspanel/org/gmitoggle.button_pressed = global.gamemodeindicator
	$settingspanel/org/ldmtoggle.button_pressed = global.lowdetailmode

func _process(delta: float) -> void:
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Music"), $settingspanel/org/filler/musicslider.value)
	$settingspanel/org/filler/sliderfill.value = $settingspanel/org/filler/musicslider.value
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("SFX"), $settingspanel/org/filler2/sfxslider.value)
	$settingspanel/org/filler2/sliderfill.value = $settingspanel/org/filler2/sfxslider.value
	


func _on_x_pressed() -> void:
	hide()

func highlight(node : Node, entered : bool):
	node.modulate = Color.WHITE if not entered else Color.WHITE * 1.3


func _on_controls_x_pressed() -> void:
	$controlspanel.hide()


func _on_tutorial_pressed() -> void:
	$controlspanel.show()


func _on_gmitoggle_toggled(toggled_on: bool) -> void:
	global.gamemodeindicator = toggled_on
	MainSaveFile.save_user_data()


func _on_ldmtoggle_toggled(toggled_on: bool) -> void:
	global.lowdetailmode = toggled_on
	MainSaveFile.save_user_data()
