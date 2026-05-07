extends Node2D

enum SIZES {MINI, NORMAL, MEGA}
@export var size : SIZES = SIZES.NORMAL
var angleinfo : Array[Dictionary] = [
	{
	"anglemod": 67.5,
	"texture": load("res://assets/mini portal.svg")
	},
	{
	"anglemod": 45,
	"texture": load("res://assets/normal portal.svg")
	},
	{
	"anglemod": 15,
	"texture": load("res://assets/mega portal.svg")
	}
]

func _ready() -> void:
	$Sprite2D.texture = angleinfo[size]["texture"]

func _on_area_2d_area_entered(area: Area2D) -> void:
	area.angle = angleinfo[size]["anglemod"]
