extends Area2D
class_name Player

signal clamped(b)


var speed : float = 1150.8957675
var dir : int = 0

func _ready() -> void:
	pass
	
func _process(delta: float) -> void:
	position.x += speed * delta
	position.y -= dir * speed * delta
	rotation_degrees = -45 * dir
	if Input.is_action_pressed("click"):
		dir = 1
	else:
		dir = -1
