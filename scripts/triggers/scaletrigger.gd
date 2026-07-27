extends LevelObject

var triggered : bool = false

func _process(delta: float) -> void:
	if not EditorGlobal.editing:
		if global.players.front().global_position.x >= global_position.x and not triggered:
			triggered = true
			for targ in targets:
				for obj in EditorGlobal.groups[targ]:
					scale_tween(obj)
	visible = EditorGlobal.editing

func scale_tween(obj : LevelObject):
	var tween = create_tween()
	tween.tween_property(obj, "scale", Vector2(targ_scale_x, targ_scale_y), duration)
	await tween.finished
