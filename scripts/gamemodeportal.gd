extends Node2D

enum GAMEMODES {NORMAL, FLUX, STAIRSMASTER, RICOCHET}
@export var gamemode : GAMEMODES = GAMEMODES.FLUX
var textures : Array[Texture2D] = [
	load("res://assets/normal mode portal sprite.svg"),
	load("res://assets/flipper portal sprite.svg"),
	load("res://assets/stairsmaster portal sprite.svg"),
	load("res://assets/ricochet portal sprite.svg")
]
var colors : Array[Color] = [
	Color("#a0e544"),
	Color("#ae47e0"),
	Color("#47ecb2"),
	Color("#ee4747")
]

func _ready() -> void:
	$Sprite2D.texture = textures[gamemode]
	$particles.modulate = colors[gamemode]

func _on_area_2d_area_entered(area: Area2D) -> void:
	match gamemode:
		GAMEMODES.NORMAL:
			area.flux = false
			area.stairsmaster.active = false
			area.ricochet.active = false
		GAMEMODES.FLUX:
			area.flux = true
			area.stairsmaster.active = false
			area.ricochet.active = false
		GAMEMODES.STAIRSMASTER:
			area.flux = false
			area.stairsmaster.active = true
			area.ricochet.active = false
		GAMEMODES.RICOCHET:
			area.flux = false
			area.stairsmaster.active = false
			area.ricochet.active = true
		
