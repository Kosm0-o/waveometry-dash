extends LevelObject

var triggered : bool = false

func _process(delta: float) -> void:
	if not EditorGlobal.editing:
		if global.players.front().global_position.x >= global_position.x and not triggered:
			triggered = true
			bg_tween()
	visible = EditorGlobal.editing

func bg_tween():
	var tween = create_tween()#.set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
	tween.tween_property(global.bg, "modulate", targ_color, duration)
	await tween.finished
