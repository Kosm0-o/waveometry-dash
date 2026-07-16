extends LevelObject

var triggered : bool = false

func _process(delta: float) -> void:
	if not EditorGlobal.editing:
		if global.players.front().global_position.x >= global_position.x and not triggered:
			triggered = true
			for targ in targets:
				for obj in EditorGlobal.groups[targ]:
					rotation_tween(obj)
	visible = EditorGlobal.editing

func rotation_tween(obj : LevelObject):
	var tween = create_tween()
	tween.tween_property(obj, "rotation_degrees", obj.rotation_degrees + targ_rot, duration)
	await tween.finished
