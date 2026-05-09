extends Node2D

enum GAMEMODES {NORMAL, FLIPPER}
@export var gamemode : GAMEMODES = GAMEMODES.FLIPPER
var textures : Array[Texture2D] = [
	load("res://assets/normal mode portal sprite.svg"),
	load("res://assets/flipper portal sprite.svg"),
]
var colors : Array[Color] = [
	Color("#fff200"),
	Color("#00dfff"),
	Color("#09fa00")
]

func _ready() -> void:
	$Sprite2D.texture = textures[gamemode]
	$particles.modulate = colors[gamemode]

func _on_area_2d_area_entered(area: Area2D) -> void:
	match gamemode:
		GAMEMODES.NORMAL:
			area.flipper = false
		GAMEMODES.FLIPPER:
			area.flipper = true
		
