extends Node2D

enum GAMEMODES {NORMAL, FLUX, STAIRSMASTER, RICOCHET}
@export var gamemode : GAMEMODES = GAMEMODES.FLUX
var modeinfo : Array[Dictionary] = [
	{
	"name": "normal",
	"color": Color("#a0e544"),
	"frontpos": Vector2(39.759, 2)
	},
	{
	"name": "flux",
	"color": Color("#ae47e0"),
	"frontpos": Vector2(39.759, 2.41)
	},
	{
	"name": "stairsmaster",
	"color": Color("#47ecb2"),
	"frontpos": Vector2(39.3, 1.5)
	},
	{
	"name": "ricochet",
	"color": Color("#ee4747"),
	"frontpos": Vector2(38.554, 0.795)
	}
]


func _ready() -> void:
	$sprites.play(modeinfo[gamemode]["name"])
	$particles.modulate = modeinfo[gamemode]["color"]
	$boop.modulate = modeinfo[gamemode]["color"]
	$boop.modulate.a = 2
	$sprites/fronthalf.position = modeinfo[gamemode]["frontpos"]

func _on_area_2d_area_entered(area: Area2D) -> void:
	$boop.emitting = true
	global.portal_entered.emit(self)
	match gamemode:
		GAMEMODES.NORMAL:
			area.flux = false
			area.stairsmaster = {"active": false, "fall": false, "holding": 0, "stopframes": 10}
			area.ricochet = {"active": false, "falling": false}
		GAMEMODES.FLUX:
			area.flux = true
			area.stairsmaster = {"active": false, "fall": false, "holding": 0, "stopframes": 10}
			area.ricochet = {"active": false, "falling": false}
		GAMEMODES.STAIRSMASTER:
			area.flux = false
			area.stairsmaster = {"active": true, "fall": false, "holding": 0, "stopframes": 10}
			area.ricochet = {"active": false, "falling": false}
		GAMEMODES.RICOCHET:
			area.flux = false
			area.stairsmaster = {"active": false, "fall": false, "holding": 0, "stopframes": 10}
			area.ricochet = {"active": true, "falling": false}
		
