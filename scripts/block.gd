extends LevelObject

func _on_hitcollision_area_entered(area) -> void:
	area = area.get_parent()
	area.die()
