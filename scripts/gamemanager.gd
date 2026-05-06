extends Node2D

@export var player : Area2D
@onready var cam: Camera2D = $Camera2D

func _process(delta: float) -> void:
	cam.global_position.x = player.global_position.x + 350
