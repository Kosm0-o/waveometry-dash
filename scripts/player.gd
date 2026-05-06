extends Area2D
class_name Player

signal clamped(b)



var speed : float = 900
var dir : int = 0
var angle : float = 45
var speedmod : float = 1

func _ready() -> void:
	await get_tree().create_timer(5.0).timeout
	
	
func _process(delta: float) -> void:
	dir = -1 if Input.is_action_pressed("click") else 1
		
	var tempangle = deg_to_rad(angle)
	var base = sin(deg_to_rad(45.0))
	
	var am : int
	if angle == 45:
		position.x += speed * speedmod * delta
		position.y += (sin(tempangle) / base) * speed * dir * speedmod * delta
		scale = Vector2(1,1)
		am = -1
	else:
		position.x += speed * speedmod * delta
		position.y += (sin(63.5) / base) * speed * dir * speedmod * 2 * delta
		scale = Vector2(0.6,0.6)
		am = 1
	
	
	rotation_degrees = lerpf(rotation_degrees,angle * dir, 20 * delta)
