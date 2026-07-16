extends LevelObject

func _process(delta: float) -> void:
	visible = EditorGlobal.editing
	global.startpos = global_position
