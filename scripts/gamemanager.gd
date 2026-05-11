extends Node2D

@export var player : Area2D
@onready var cam: Camera2D = $Camera2D
@onready var players: Node2D = $players


func _process(delta: float) -> void:
	cam.global_position.x = player.global_position.x + 500
	if global.lowdetailmode and not global.complete_details:
		Engine.max_fps = 60
		$WorldEnvironment.environment.glow_enabled = false
		$CanvasModulate.color = Color.WHITE
		for pr in get_tree().get_nodes_in_group("particles"):
			if pr is GPUParticles2D:
				pr.emitting = false
				pr.hide()
		global.complete_details = true
	elif not global.lowdetailmode and not global.complete_details:
		Engine.max_fps = 0
		$WorldEnvironment.environment.glow_enabled = true
		$CanvasModulate.color = Color("#ff5a52")
		for pr in get_tree().get_nodes_in_group("particles"):
			if pr is GPUParticles2D:
				pr.emitting = true
				pr.show()
		global.complete_details = true
