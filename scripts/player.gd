extends CharacterBody2D
class_name Player

var basespeed : float = 900
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
var respawning : bool = false
var respawn_timer : float = 0.0
var respawn_cooldown : float = 0.4
var y_boost : float = 0.0 # for jump pads
var sliding : bool = false
var dashing : Dictionary = {"true": false, "pink": false}
var ceiling : bool = false # for gamemodes
var flooring : bool = false # also for gamemodes
var dropping : bool = false
var prev_wall_norm : Vector2 = Vector2.ZERO

func _ready() -> void:
	$UI/CheckpointsUI/add.pressed.connect(place_checkpoint)
	$UI/CheckpointsUI/remove.pressed.connect(remove_current_checkpoint)
	await get_tree().create_timer(0.2).timeout
	if not dual:
		if not global.playtest: die()
	else:
		name = "Player2"
	await get_tree().create_timer(7.5).timeout
	
	
func _physics_process(delta: float) -> void:
	if not dropping and y_boost > 0:
		y_boost = lerpf(y_boost, 0, 15 * delta)
	
	
	if respawning:
		respawn_timer += delta
		modulate.a = sin(respawn_timer * 25.0) * 0.4 + 0.5
		if Engine.time_scale == 1.0:
			respawning = false
			modulate.a = 1
			respawn_timer = 0.0
	
	if dashing["true"]:
		dir = 0
		if not Input.is_action_pressed("click") or is_on_wall():
			dashing["true"] = false
			if dashing.pink:
				angle *= -1
				dashing.pink = false
	elif  not (flux or stairsmaster.active or ricochet.active):
		dir = -1 if Input.is_action_pressed("click") else 1
		dir = dir * -1 if dual else dir
	elif Input.is_action_just_pressed("click") and flux:
		dir *= -1
		if dual:
			var og_player : Player = global.players.filter(func(p): return p != self).front()
			dir = 1 if og_player.dir == -1 else -1
	elif stairsmaster.active:
		if (ceiling and not dual) or (flooring and dual):
			stairsmaster.fall = true if not dual else false
		elif (flooring and not dual) or (ceiling and dual):
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
		if (ceiling and not dual) or (flooring and dual):
			ricochet.falling = true if not dual else false
		elif (flooring and not dual) or (ceiling and dual):
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
	
	var move : Vector2 = Vector2.ZERO

	if abs(angle) == 45:
		move.x = speed * speedmod
		move.y = (sin(tempangle) / base) * speed * dir * speedmod - y_boost
		scale = Vector2.ONE
	elif abs(angle) == 15:
		move.x = speed * speedmod
		move.y = (sin(15) / base) * speed * dir * speedmod - y_boost
		scale = Vector2(1.55,1.55)
	else:
		move.x = speed * speedmod
		move.y = (sin(63.425) / base) * speed * dir * speedmod * 2 - y_boost
		scale = Vector2(0.6,0.6)
	
	sliding = false
	var wall_norm : Vector2 = Vector2.ZERO
	if is_on_wall():
		for i in get_slide_collision_count():
			var c = get_slide_collision(i)
			var norm = c.get_normal()
			ceiling = norm.y > 0 and Input.is_action_pressed("click")
			flooring = norm.y < 0 and not Input.is_action_pressed("click")
			if not ceiling and not flooring:
				continue
			wall_norm += norm
			if ceiling or flooring:
				sliding = true
		if wall_norm != Vector2.ZERO:
			wall_norm = wall_norm.normalized()
			prev_wall_norm = wall_norm
	if sliding:
		if abs(prev_wall_norm.x) < 0.01:
			velocity = move.limit_length(speed * speedmod)
		else:
			var tang : Vector2 = Vector2(prev_wall_norm.y, -prev_wall_norm.x)
			if tang.x < 0:
				tang *= -1
			velocity = (tang * (speed * speedmod / tang.x) - prev_wall_norm * speed * speedmod)
	else:
		velocity = move
	move_and_slide()
	if is_on_wall():
		y_boost = 0
		dropping = false
	
	var mult : float = 1.0
	if abs(angle) == 15: mult = 2.0
	elif abs(angle) == 63.425: mult = 0.85
	var norm_targ = angle * dir * mult
	var slope_targ = rad_to_deg(prev_wall_norm.angle()) - 90
	if prev_wall_norm.y < 0:
		slope_targ += 180
	var targ_rot = slope_targ if sliding else norm_targ
	$visualoffset.rotation_degrees = lerpf($visualoffset.rotation_degrees, targ_rot, 20 * delta)
	$grounded.speed_scale = 1 if sliding else 5
	$grounded.emitting = sliding
	
	




func die():
	visible = false
	trail_node.visible = false
	speed = 0
	if global.playtest:
		global.playtest = false
		get_tree().call_deferred("change_scene_to_file","res://scenes/editor.tscn")
		return
	await get_tree().create_timer(respawn_cooldown).timeout
	if global.practice_mode and global.all_checkpoints.size() > 0:
		go_to_checkpoint(global.all_checkpoints.back())
	else:
		if dual: 
			global.players.filter(func(p): return p != self).front().die()
			trail_node.queue_free()
			queue_free()
		flux = false # switch gravity on click
		stairsmaster = {"active": false, "fall": false, "holding": 0, "stopframes": 10} # climb the stairs, fall to the bottom, start again
		ricochet = {"active": false, "falling": false}
		ogspeedmod = 1
		speedmod = 1
		angle = 45
		global_position = Vector2.ZERO
		trail_node.reset()
	visible = true
	trail_node.visible = true
	if global.practice_mode:
		Engine.time_scale = 0.3
	speed = basespeed
	respawning = true
	global.died.emit()
	
func remove_current_checkpoint():
	var cur = global.all_checkpoints.back() if global.all_checkpoints.size() > 0 else null
	if is_instance_valid(cur):
		global.all_checkpoints.erase(cur)
		cur.queue_free()

func go_to_checkpoint(c):
	checkpoint_timer = checkpoint_time
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
