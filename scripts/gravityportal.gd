extends Node2D

enum TYPES {UP, DOWN, FLIP}
@export var gravity : TYPES = TYPES.DOWN
var textures : Array[Texture2D] = [
	load("res://assets/up gravity portal.svg"),
	load("res://assets/down gravity portal.svg"),
	load("res://assets/flip gravity portal.svg")
]
var colors : Array[Color] = [
	Color("#fff200"),
	Color("#00dfff"),
	Color("#09fa00")
]

func _ready() -> void:
	$Sprite2D.texture = textures[gravity]
	$particles.modulate = colors[gravity]

func _on_area_2d_area_entered(area: Area2D) -> void:
	if gravity == TYPES.FLIP:
		area.angle *= -1
	else:
		var check = sign(area.angle) == 1
		match gravity:
			TYPES.DOWN:
				if not check: area.angle *= -1
			TYPES.UP:
				if check: area.angle *= -1
			
