extends Node2D

@export var player : Area2D
@onready var cam: Camera2D = $Camera2D
@onready var players: Node2D = $players

func _process(delta: float) -> void:
	cam.global_position.x = player.global_position.x + 500
