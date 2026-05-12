extends Node2D

enum SIZES {MINI, NORMAL, MEGA}
@export var size : SIZES = SIZES.NORMAL
var angleinfo : Array[Dictionary] = [
	{
	"name": "mini",
	"anglemod": 67.5
	},
	{
	"name": "normal",
	"anglemod": 45
	},
	{
	"name": "mega",
	"anglemod": 15
	}
]

func _ready() -> void:
	$sprites.play(angleinfo[size]["name"])

func _on_area_2d_area_entered(area: Area2D) -> void:
	area.angle = angleinfo[size]["anglemod"] * sign(area.angle)
