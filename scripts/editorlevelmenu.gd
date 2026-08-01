extends Control

func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	MainSaveFile.save_user_data()
	RenderingServer.set_default_clear_color(Color.BLACK)
	EditorGlobal.editing = false
	global.main_level = false
	global.trans_rect = $trans/ColorRect
	global.fade_tween(false)
	setup_custom_level_panels()
	for btn in [
		$back,
		$newlvl,
		$importlevel
	]:
		if btn is Button:
			btn.mouse_entered.connect(
				func():
					btn.modulate *= 1.3
			)
			btn.mouse_exited.connect(
				func():
					btn.modulate = Color.WHITE
			)
	$importpanel.fake_objects_node = $fakeobjectsnode

func _process(delta: float) -> void:
	$substitutelevelpanel/Label.visible = $substitutelevelpanel/ScrollContainer/customlevels.get_children().size() <= 0
	$importlevel.disabled = $importpanel.visible

func _on_back_pressed() -> void:
	await global.fade_tween(true)
	get_tree().change_scene_to_file("res://scenes/mainmenu.tscn")

func setup_custom_level_panels():
	for panel in $substitutelevelpanel/ScrollContainer/customlevels.get_children():
		panel.queue_free()
	for i in range(EditorGlobal.custom_levels.size()):
		var lvlfile = FileAccess.get_file_as_string(EditorGlobal.custom_levels[i])
		var data = JSON.parse_string(lvlfile)
		var new_panel = preload("res://scenes/customlevelpanel.tscn").instantiate()
		$substitutelevelpanel/ScrollContainer/customlevels.add_child(new_panel)
		new_panel.label.text = data.level_name
		new_panel.lvl = EditorGlobal.custom_levels[i]
		new_panel.self_modulate = Color("#a2572d") if i % 2 == 0 else new_panel.self_modulate


func _on_newlvl_pressed() -> void:
	var newlvlname : String = "NewLevel_"  + str(Time.get_unix_time_from_system())
	var path : String = "user://customlevels/" + newlvlname + ".json"
	LevelLoader.save_level(path, $fakeobjectsnode, {"level_name": newlvlname})
	EditorGlobal.custom_levels.append(path)
	setup_custom_level_panels()

func switch_to_editor():
	await global.fade_tween(true)
	get_tree().change_scene_to_file("res://scenes/editor.tscn")


func _on_importlevel_pressed() -> void:
	$importpanel.show()
