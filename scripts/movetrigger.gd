extends LevelObject

var triggered : bool = false

func _process(delta: float) -> void:
	if not EditorGlobal.editing:
		if global.players.front().global_position.x >= global_position.x and not triggered:
			triggered = true
			for targ in targets:
				for obj in EditorGlobal.groups[targ]:
					move_tween(obj)
	visible = EditorGlobal.editing

func move_tween(obj : LevelObject):
	var tween = create_tween()
	tween.tween_property(obj, "global_position", obj.global_position + Vector2(move_x, move_y), duration)
	await tween.finished
