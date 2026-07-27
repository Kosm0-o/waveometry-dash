extends LevelObject

var triggered : bool = false

func _process(delta: float) -> void:
	if not EditorGlobal.editing:
		if global.players.front().global_position.x >= global_position.x and not triggered:
			triggered = true
			for targ in targets:
				for obj in EditorGlobal.groups[targ]:
					color_tween(obj)
	visible = EditorGlobal.editing

func color_tween(obj : LevelObject):
	var tween = create_tween()
	tween.tween_property(obj, "modulate", targ_color, duration)
	await tween.finished
