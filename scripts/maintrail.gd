extends Node2D
class_name Trail

@onready var l1: Line2D = $line1
@onready var l2: Line2D = $line2
@export var player : Player
var points 

func _ready() -> void:
	player.trail_node = self

func _process(delta: float) -> void:
	points = l1.points

func set_points(ps):
	for l in get_children():
		l.points = ps

func reset():
	for l in get_children():
		l.clear_points()
		l.starter_frames = 250
