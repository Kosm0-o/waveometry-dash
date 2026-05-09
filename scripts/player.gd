extends Area2D
class_name Player

signal clamped(b)



var speed : float = 900
var dir : int = 1
var angle : float = 45
var speedmod : float = 1
var ogspeedmod : float = 1
var dual : bool = false
var trail_node : Trail = null
var flipper : bool = false


func _ready() -> void:
	await get_tree().create_timer(5.0).timeout
	
	
func _process(delta: float) -> void:
	if not flipper:
		dir = -1 if Input.is_action_pressed("click") else 1
		dir = dir * -1 if dual else dir
	elif Input.is_action_just_pressed("click"):
		dir *= -1

	
	var tempangle = deg_to_rad(angle)
	var base = sin(deg_to_rad(45.0))
	
	if abs(angle) == 45:
		position.x += speed * speedmod * delta
		position.y += (sin(tempangle) / base) * speed * dir * speedmod * delta
		scale = Vector2(1,1)
	elif abs(angle) == 15:
		position.x += speed * speedmod * delta
		position.y += (sin(15) / base) * speed * dir * speedmod * 0.8 * delta
		scale = Vector2(1.55,1.55)
	else:
		position.x += speed * speedmod * delta
		position.y += (sin(67.5) / base) * speed * dir * speedmod * -2.5 * delta
		scale = Vector2(0.6,0.6)
	
	var ycheck : bool= position.y > -630 and position.y < 630
	if ycheck:
		var mult : float = 1.0 if angle != 15 else 2.0
		rotation_degrees = lerpf(rotation_degrees, angle * dir * mult, 20 * delta)
	else:
		rotation_degrees = lerpf(rotation_degrees, 0, 20 * delta)
	$grounded.emitting = not ycheck
	position.y = clamp(position.y,-630,630)
