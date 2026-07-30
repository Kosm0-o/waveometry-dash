extends Panel

@onready var label: Label = $Label
var lvl = null
var oglabeltxt : String = ""

func _ready() -> void:
	for btn in get_children():
		if btn is Button:
			btn.mouse_entered.connect(highlight.bind(btn, true))
			btn.mouse_exited.connect(highlight.bind(btn, false))

func _process(delta: float) -> void:
	if label.size.x > 636.0:
		var div = (636.0 / label.size.x)
		label.label_settings.font_size = 33.0 * div
		label.label_settings.outline_size = 18.0 * div
		label.label_settings.shadow_size = 7.0 * div


func _on_button_pressed() -> void:
	EditorGlobal.current_lvl = lvl
	get_tree().current_scene.switch_to_editor()


func _on_deletebtn_pressed() -> void:
	oglabeltxt = $Label.text
	$Label.text = "Are you sure?"
	$editbtn.hide()
	$deletebtn.hide()
	$yesbtn.show()
	$nobtn.show()

func _on_yesbtn_pressed() -> void:
	var error = DirAccess.remove_absolute(lvl)
	if error == OK:
		print("File successfully deleted")
	else:
		push_error("Failed to delete file. Error code: ", error)
	EditorGlobal.custom_levels.erase(lvl)
	get_tree().current_scene.setup_custom_level_panels()
	queue_free()
	

func _on_nobtn_pressed() -> void:
	$Label.text = oglabeltxt
	$editbtn.show()
	$deletebtn.show()
	$yesbtn.hide()
	$nobtn.hide()

func highlight(node : Node, entered : bool):
	node.modulate = Color.WHITE if not entered else Color.WHITE * 1.3
