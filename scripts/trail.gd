extends Line2D

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("click") or Input.is_action_just_released("click"):
		add_point(get_parent().position)
		
