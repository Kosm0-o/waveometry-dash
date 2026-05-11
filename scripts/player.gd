extends Area2D
class_name Player



var speed : float = 900
var dir : int = 1
var angle : float = 45
var speedmod : float = 1
var ogspeedmod : float = 1
var dual : bool = false
var trail_node : Trail = null
var flux : bool = false # switch gravity on click
var stairsmaster : Dictionary = {"active": false, "fall": false, "holding": 0, "stopframes": 10} # climb the stairs, fall to the bottom, start again
var ricochet : Dictionary = {"active": false, "falling": false} # bouncy, bouncy, STOP


func _ready() -> void:
	await get_tree().create_timer(0.2).timeout
	if not dual:
		die()
	else:
		name = "Player2"
	await get_tree().create_timer(5.0).timeout
	
	
func _process(delta: float) -> void:
	if not (flux or stairsmaster.active or ricochet.active):
		dir = -1 if Input.is_action_pressed("click") else 1
		dir = dir * -1 if dual else dir
	elif Input.is_action_just_pressed("click") and flux:
		dir *= -1
	elif stairsmaster.active:
		if position.y <= -global.bounds + 25:
			stairsmaster.fall = true
		elif position.y >= global.bounds - 25:
			stairsmaster.fall = false
		if stairsmaster.fall:
			dir = 1
			stairsmaster.holding = 0
		elif Input.is_action_pressed("click"):
			if stairsmaster.holding > 0.35:
				stairsmaster.stopframes -= 1
				dir = 0
				if stairsmaster.stopframes <= 0:
					stairsmaster.holding = 0
					stairsmaster.stopframes = 10
			else:
				dir = -1
				stairsmaster.holding += delta
		else:
			dir = 0
			stairsmaster.holding = 0
	elif ricochet.active:
		if position.y <= -global.bounds + 25:
			ricochet.falling = true
		elif position.y >= global.bounds - 25:
			ricochet.falling = false
		if Input.is_action_pressed("click"):
			dir = 0
		elif ricochet.falling:
			dir = 1
		else:
			dir = -1
	
	var tempangle = deg_to_rad(angle)
	var base = sin(deg_to_rad(45.0))
	
	if abs(angle) == 45:
		position.x += speed * speedmod * delta
		position.y += (sin(tempangle) / base) * speed * dir * speedmod * delta
		scale = Vector2(1,1)
	elif abs(angle) == 15:
		position.x += speed * speedmod * delta
		position.y += (sin(15) / base) * speed * dir * speedmod * 1.0 * delta #og 0.8
		scale = Vector2(1.55,1.55)
	else:
		position.x += speed * speedmod * delta
		position.y += (sin(67.5) / base) * speed * dir * speedmod * -2 * delta #og -2.5
		scale = Vector2(0.6,0.6)
	
	var ycheck : bool = position.y > -global.bounds and position.y < global.bounds
	if ycheck:
		var mult : float = 1.0 if angle != 15 else 2.0
		rotation_degrees = lerpf(rotation_degrees, angle * dir * mult, 20 * delta)
	else:
		rotation_degrees = lerpf(rotation_degrees, 0, 20 * delta)
	$grounded.emitting = not ycheck
	position.y = clamp(position.y,-global.bounds,global.bounds)

func die():
	if dual: 
		global.players.filter(func(p): return p != self).front().die()
		trail_node.queue_free()
		queue_free()
	$atsol.stop()
	$atsol.play(20.0)
	ogspeedmod = 1
	speedmod = 1
	angle = 45
	global_position = Vector2(27422.0, -30.0)#Vector2.ZERO
	trail_node.clear_points()
	
