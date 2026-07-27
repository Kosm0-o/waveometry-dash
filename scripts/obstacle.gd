extends LevelObject
class_name Hazard

@export var saw : bool = false

func _process(delta: float) -> void:
	if saw and not EditorGlobal.editing:
		rotation_degrees += 5

func _on_area_2d_area_entered(area) -> void:
	area = area.get_parent()
	area.die()
