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
var checkpoint_time : float = 3.0
var checkpoint_timer : float = 0.0

func _ready() -> void:
	$UI/CheckpointsUI/add.pressed.connect(place_checkpoint)
	$UI/CheckpointsUI/remove.pressed.connect(remove_current_checkpoint)
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
		if dual:
			var og_player : Player = global.players.filter(func(p): return p != self).front()
			dir = 1 if og_player.dir == -1 else -1
	elif stairsmaster.active:
		if position.y <= -global.bounds + 25:
			stairsmaster.fall = true if not dual else false
		elif position.y >= global.bounds - 25:
			stairsmaster.fall = false if not dual else true
		if stairsmaster.fall:
			dir = 1 if not dual else -1
			stairsmaster.holding = 0
		elif Input.is_action_pressed("click"):
			if stairsmaster.holding > 0.35:
				stairsmaster.stopframes -= 1
				dir = 0
				if stairsmaster.stopframes <= 0:
					stairsmaster.holding = 0
					stairsmaster.stopframes = 10
			else:
				dir = -1 if not dual else 1
				stairsmaster.holding += delta
		else:
			dir = 0
			stairsmaster.holding = 0
	elif ricochet.active:
		if dual:
			print(ricochet.falling)
		if position.y <= -global.bounds + 25:
			ricochet.falling = true if not dual else false
		elif position.y >= global.bounds - 25:
			ricochet.falling = false if not dual else true
		if Input.is_action_pressed("click"):
			dir = 0
		elif ricochet.falling:
			dir = 1 if not dual else -1
		else:
			dir = -1 if not dual else 1
	
	if global.practice_mode:
		checkpoint_timer -= delta
		if checkpoint_timer <= 0.0:
			if not dual:
				place_checkpoint()
			checkpoint_timer = checkpoint_time
	$UI/CheckpointsUI.visible = global.practice_mode
	
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
	
	var ycheck : bool = position.y > -global.bounds + global.cam_offset and position.y < global.bounds + global.cam_offset
	var xcheck : bool = position.x > -global.bounds + global.cam_offset and position.x < global.bounds + global.cam_offset
	bounds_checking(ycheck, xcheck, global.yangle, global.xangle, delta)


func bounds_checking(ycheck : bool, xcheck : bool, yangle : bool, xangle : bool, delta):
	# y angle means you travel vertically and use ycheck, x angle means you tarvel horizontally and use xcheck
#	print(str(ycheck) + " " + str(xangle) + "    " + str(xcheck) + " " + str(yangle))
	if (ycheck and xangle) or (xcheck and yangle):
		var mult : float = 1.0 if angle != 15 else 2.0
		rotation_degrees = lerpf(rotation_degrees, angle * dir * mult, 20 * delta)
	else:
		rotation_degrees = lerpf(rotation_degrees, 0, 20 * delta)
	$grounded.emitting = not ycheck if xangle else not xcheck
	position.y = clamp(position.y,-global.bounds + global.cam_offset,global.bounds + global.cam_offset)

func die():
	if global.practice_mode and global.all_checkpoints.size() > 0:
		go_to_checkpoint(global.all_checkpoints.back())
		return
	if dual: 
		global.players.filter(func(p): return p != self).front().die()
		trail_node.queue_free()
		queue_free()
	$atsol.stop()
	$atsol.play()
	ogspeedmod = 1
	speedmod = 1
	angle = 45
	global_position = Vector2.ZERO
	trail_node.reset()

func remove_current_checkpoint():
	var cur = global.all_checkpoints.back() if global.all_checkpoints.size() > 0 else null
	if is_instance_valid(cur):
		global.all_checkpoints.erase(cur)
		cur.queue_free()

func go_to_checkpoint(c):
	var dual_player : Player = global.players.filter(func(p): return p != self).front() if global.dualing else null
	angle = c.data.angle
	speedmod = c.data.speedmod
	flux = c.data.gamemodes.flux
	stairsmaster = c.data.gamemodes.stairsmaster
	ricochet = c.data.gamemodes.ricochet
	trail_node.set_points(c.data.trail_points) 
	global_position = c.global_position
	if dual_player != null and c.data.dual.bool:
		dual_player.angle = c.data.dual.dual_angle
		dual_player.speedmod = c.data.dual.dual_speedmod
		dual_player.flux = c.data.dual.dual_gamemodes.flux
		dual_player.stairsmaster = c.data.dual.dual_gamemodes.stairsmaster
		dual_player.ricochet = c.data.dual.dual_gamemodes.ricochet
		dual_player.trail_node.set_points(c.data.dual.dual_trail_points)
		dual_player.global_position = c.data.dual.dual_pos

func place_checkpoint():
	var checkpoint = preload("res://scenes/checkpoint.tscn").instantiate()
	var dual_player : Player = global.players.filter(func(p): return p != self).front() if global.dualing else null
	checkpoint.data = {
		"angle": angle,
		"gamemodes": {
					"flux": flux,
					"stairsmaster": stairsmaster,
					"ricochet": ricochet
					},
		"dual": {"bool": global.dualing},
		"speedmod": speedmod,
		"trail_points": trail_node.points
	}
	if dual_player != null:
		checkpoint.data.dual = {
								"bool": global.dualing,
								"dual_pos": dual_player.global_position,
								"dual_angle": dual_player.angle, 
								"dual_gamemodes": {
													"flux": dual_player.flux,
													"stairsmaster": dual_player.stairsmaster,
													"ricochet": dual_player.ricochet
													}, 
								"dual_speedmod": dual_player.speedmod, 
								"dual_trail_points": dual_player.trail_node.points
								}
	get_tree().current_scene.get_node("Map").add_child(checkpoint)
	checkpoint.global_position = global_position
