extends Node2D

enum SPEEDS {SLOW, NORMAL, DOUBLE, TRIPLE, QUAD, BURST}
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
	},
	{
	"speedmod": 2.3,
	"texture": load("res://assets/burst speed sprite.svg")
	},
]

func _ready() -> void:
	$Sprite2D.texture = speedinfo[speed]["texture"]

func _on_area_2d_area_entered(area: Area2D) -> void:
	flash_tween()
	if not speed == SPEEDS.BURST:
		for p in global.players:
			p.ogspeedmod = p.speedmod
			p.speedmod = speedinfo[speed]["speedmod"]

	else:
		for p in global.players:
			p.speedmod = speedinfo[speed]["speedmod"]
		await get_tree().create_timer(0.25).timeout
		for p in global.players:
			print(p.name)
			var tween = create_tween().set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_EXPO)
			tween.tween_property(p, "speedmod", p.ogspeedmod, 1.0)
			await tween.finished
			p.speedmod = p.ogspeedmod

func flash_tween():
	var tween = create_tween()
	var og = $Sprite2D.modulate
	tween.tween_property($Sprite2D, "modulate", Color.GHOST_WHITE, 0.1).set_ease(Tween.EASE_IN)
	tween.tween_property($Sprite2D, "modulate", og, 0.4).set_ease(Tween.EASE_OUT)
	await tween.finished
