extends LevelObject

func _process(delta: float) -> void:
	modulate = Color(0,0,0,0.00784313725) if not EditorGlobal.editing else mod
