extends Control

@onready var musicslider: HSlider = $settingspanel/org/filler/musicslider
@onready var sfxslider: HSlider = $settingspanel/org/filler2/sfxslider

func _process(delta: float) -> void:
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Music"), $settingspanel/org/filler/musicslider.value)
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("SFX"), $settingspanel/org/filler2/sfxslider.value)


func _on_x_pressed() -> void:
	hide()
