extends Node2D
class_name Trail

@onready var l1: Line2D = $line1
@onready var l2: Line2D = $line2
@export var player : Player

func _ready() -> void:
	player.trail_node = self

func clear_points():
	for l in get_children():
		l.clear_points()
		l.starter_frames = 100
