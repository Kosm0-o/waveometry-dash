extends Node2D

@export var player : Area2D
@onready var cam: Camera2D = $Camera2D
@onready var bg: ColorRect = $bg

func _process(delta: float) -> void:
	cam.global_position = player.global_position + Vector2(50, 0)
	bg.global_position = player.global_position
