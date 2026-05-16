extends Node2D

@export var player : Area2D
@onready var cam: Camera2D = $Camera2D
@onready var players: Node2D = $Map/players
var cam_x_point : float = 0
var cam_y_point : float = 0
@onready var map: Node2D = $Map
var past_rotation_tweening : bool = false
var frames : int = 0
var target_shift_pos : Vector2 = Vector2.ZERO

func _ready() -> void:
	global.portal_entered.connect(_shift_camera)


func _process(delta: float) -> void:
	global.cam_offset = cam.global_position.y
	map.rotation_degrees = global.layout_rotation
	var offset : float
	if target_shift_pos.x == 0:
		cam.global_position.y = lerp(cam.global_position.y, target_shift_pos.y, 10 * delta)
	elif target_shift_pos.y == 0:
		cam.global_position.x = lerp(cam.global_position.x, target_shift_pos.x, 10 * delta)
		
	match global.layout_rotation:
		0, 360:
			offset = 500
		90:
			offset = -250
		180:
			offset = -500
		270:
			offset = 250
	if global.rotation_tweening or frames > 0:
		cam.global_position = player.global_position
		frames -= 1
	elif global.rotation_tweening != past_rotation_tweening:
		frames = 0
	elif global.xangle:
		cam.global_position.x = player.global_position.x + 500
	elif global.yangle:
		cam.global_position.y = player.global_position.y + offset
		
	
	if global.lowdetailmode and not global.complete_details:
		Engine.max_fps = 60
		DisplayServer.window_set_vsync_mode(DisplayServer.VSYNC_MAILBOX)
		
		$WorldEnvironment.environment.glow_enabled = false
		for pr in get_tree().get_nodes_in_group("particles"):
			if pr is GPUParticles2D:
				pr.emitting = false
				pr.hide()
		global.complete_details = true
	elif not global.lowdetailmode and not global.complete_details:
		Engine.max_fps = 0
		DisplayServer.window_set_vsync_mode(DisplayServer.VSYNC_ENABLED)
		$WorldEnvironment.environment.glow_enabled = true
		for pr in get_tree().get_nodes_in_group("particles"):
			if pr is GPUParticles2D:
				pr.emitting = true
				pr.show()
		global.complete_details = true
	
	past_rotation_tweening = global.rotation_tweening

func _shift_camera(portal):
	if abs(portal.global_position.y - cam.global_position.y) < 100:
		return
	if global.xangle:
		target_shift_pos.y = portal.global_position.y
		target_shift_pos.x = 0
	elif global.yangle:
		target_shift_pos.x = portal.global_position.x
		target_shift_pos.y = 0
