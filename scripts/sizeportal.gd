extends Node2D

enum SIZES {MINI, NORMAL, MEGA}
@export var size : SIZES = SIZES.NORMAL
var angleinfo : Array[Dictionary] = [
	{
	"name": "mini",
	"anglemod": 67.5,
	"color": Color("#ff7cf9")
	},
	{
	"name": "normal",
	"anglemod": 45,
	"color": Color("#05ff45")
	},
	{
	"name": "mega",
	"anglemod": 15,
	"color": Color("#0506ff")
	}
]

func _ready() -> void:
	$sprites.play(angleinfo[size]["name"])
	$particles.modulate = angleinfo[size]["color"]
	$boop.modulate = angleinfo[size]["color"]
	$boop.modulate.a = 2

func _on_area_2d_area_entered(area: Area2D) -> void:
	$boop.emitting = true
	global.portal_entered.emit(self)
	area.angle = angleinfo[size]["anglemod"] * sign(area.angle)
