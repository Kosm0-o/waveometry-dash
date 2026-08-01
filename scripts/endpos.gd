extends LevelObject

func object_ready() -> void:
	global.endpos = self

func _process(delta: float) -> void:
	$Panel.visible = EditorGlobal.editing
	if not EditorGlobal.editing:
		global_position.y = global.players.front().global_position.y




func _on_playerchecker_body_entered(body: Node2D) -> void:
	if global.main_level:
		global.progress[global.main_level_id] = 100.0
	body.win()
