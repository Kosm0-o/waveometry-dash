extends Node2D

enum SPEEDS {SLOW, NORMAL, DOUBLE, TRIPLE, QUAD}
@export var speed : SPEEDS
var speedinfo : Array[Dictionary] = [
	{
	"speedmod": 0.8,
	"texture": load("res://assets/slow speed sprite.svg")
	},
	{
	"speedmod": 1.0,
	"texture": load("res://assets/normal speed sprite.svg")
	},
	{
	"speedmod": 1.45,
	"texture": load("res://assets/double speed sprite.svg")
	},
	{
	"speedmod": 1.8,
	"texture": load("res://assets/triple speed sprite.svg")
	},
	{
	"speedmod": 2.19,
	"texture": load("res://assets/quad speed sprite.svg")
	}
]

func _ready() -> void:
	$Sprite2D.texture = speedinfo[speed]["texture"]

func _on_area_2d_area_entered(area: Area2D) -> void:
	area.speedmod = speedinfo[speed]["speedmod"]
