extends Node2D

enum TYPES {UP, DOWN, FLIP}
@export var gravity : TYPES = TYPES.DOWN
var gravityinfo : Array[Dictionary] = [
	{
	"name": "up",
	"color": Color("#fff200"),
	"frontpos": Vector2(51, -1.205)
	},
	{
	"name": "down",
	"color": Color("#00dfff"),
	"frontpos": Vector2(51, 0)
	},
	{
	"name": "flip",
	"color": Color("#09fa00"),
	"frontpos": Vector2(48.59, 3.614)
	}
]

func _ready() -> void:
	$sprites.play(gravityinfo[gravity]["name"])
	$particles.modulate = gravityinfo[gravity]["color"]
	$sprites/fronthalf.position = gravityinfo[gravity]["frontpos"]

func _on_area_2d_area_entered(area: Area2D) -> void:
	global.portal_entered.emit(self)
	if gravity == TYPES.FLIP:
		area.angle *= -1
	else:
		var check = sign(area.angle) == 1
		match gravity:
			TYPES.DOWN:
				if not check: area.angle *= -1
			TYPES.UP:
				if check: area.angle *= -1
			
