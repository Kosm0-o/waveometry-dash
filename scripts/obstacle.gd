extends Area2D

@export var saw : bool = false

func _process(delta: float) -> void:
	if saw:
		rotation_degrees += 1

func _on_area_entered(area: Area2D) -> void:
	area.die()
