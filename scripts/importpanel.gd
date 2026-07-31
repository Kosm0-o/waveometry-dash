extends Control

@onready var filedataedit: TextEdit = $importpanelstuff/texteditpanel/filedataedit
var fake_objects_node : Node

func _ready() -> void:
	$X.mouse_entered.connect(highlight.bind($X, true))
	$X.mouse_exited.connect(highlight.bind($X, false))
	$importlevel.mouse_entered.connect(highlight.bind($importlevel, true))
	$importlevel.mouse_exited.connect(highlight.bind($importlevel, false))

func _process(delta: float) -> void:
	$importpanelstuff/texteditpanel/filedataedit/Label.visible = len($importpanelstuff/texteditpanel/filedataedit.text) <= 0

func _on_x_pressed() -> void:
	hide()

func highlight(node : Node, entered : bool):
	node.modulate = Color.WHITE if not entered else Color.WHITE * 1.3


func _on_importlevel_pressed() -> void:
	var inputfile : String = filedataedit.text
	if len(inputfile) > 0:
		if LevelLoader.validate_level_file(inputfile):
			var newlvlname : String = "ImportedLevel_" + str(Time.get_unix_time_from_system())
			var path : String = "user://customlevels/" + newlvlname + ".json"
			var file = FileAccess.open(path, FileAccess.WRITE)
			file.store_string(inputfile)
			file.close()
			EditorGlobal.custom_levels.append(path)
			get_parent().setup_custom_level_panels()
			success_popup()
			return
	invalid_popup()
	

func invalid_popup():
	$invalidpopup.show()
	await get_tree().create_timer(2.0).timeout
	$invalidpopup.hide()

func success_popup():
	$successpopup.show()
	await get_tree().create_timer(2.0).timeout
	$successpopup.hide()
