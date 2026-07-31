extends Control

var t : float = 0.0

func _ready() -> void:
	$X.mouse_entered.connect(highlight.bind($X, true))
	$X.mouse_exited.connect(highlight.bind($X, false))
	$copytoclipboard.mouse_entered.connect(highlight.bind($copytoclipboard, true))
	$copytoclipboard.mouse_exited.connect(highlight.bind($copytoclipboard, false))
	var file = FileAccess.open(EditorGlobal.current_lvl, FileAccess.READ)
	if file:
		var data = file.get_as_text()
		$exportpanelstuff/texteditpanel/filedataedit.text = data

func _process(delta: float) -> void:
	t += delta
	$Label.scale = Vector2.ONE * (sin(t * 5.0) * 0.08 + 1.0)

func highlight(node : Node, entered : bool):
	node.modulate = Color.WHITE if not entered else Color.WHITE * 1.3

func _on_x_pressed() -> void:
	hide()


func _on_copytoclipboard_pressed() -> void:
	DisplayServer.clipboard_set($exportpanelstuff/texteditpanel/filedataedit.text)
	$copiedpopup.show()
	await get_tree().create_timer(1.5).timeout
	$copiedpopup.hide()
