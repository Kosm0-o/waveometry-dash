extends Control

func _ready() -> void:
	$X.mouse_entered.connect(highlight.bind($X, true))
	$X.mouse_exited.connect(highlight.bind($X, false))
	$settingspanel/org/filler/musicslider.mouse_entered.connect(highlight.bind($settingspanel/org/filler, true))
	$settingspanel/org/filler/musicslider.mouse_exited.connect(highlight.bind($settingspanel/org/filler, false))
	$settingspanel/org/filler2/sfxslider.mouse_entered.connect(highlight.bind($settingspanel/org/filler2, true))
	$settingspanel/org/filler2/sfxslider.mouse_exited.connect(highlight.bind($settingspanel/org/filler2, false))

func _process(delta: float) -> void:
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Music"), $settingspanel/org/filler/musicslider.value)
	$settingspanel/org/filler/sliderfill.value = $settingspanel/org/filler/musicslider.value
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("SFX"), $settingspanel/org/filler2/sfxslider.value)
	$settingspanel/org/filler2/sliderfill.value = $settingspanel/org/filler2/sfxslider.value
	


func _on_x_pressed() -> void:
	hide()

func highlight(node : Node, entered : bool):
	node.modulate = Color.WHITE if not entered else Color.WHITE * 1.3
