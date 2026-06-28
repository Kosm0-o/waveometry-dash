extends LevelObject

enum SPEEDS {SLOW, NORMAL, DOUBLE, TRIPLE, QUAD, BURST}
@export var speed : SPEEDS
var speedinfo : Array[Dictionary] = [
	{
	"name": "slow",
	"speedmod": 0.8
	},
	{
	"name": "normal",
	"speedmod": 1.0
	},
	{
	"name": "double",
	"speedmod": 1.45
	},
	{
	"name": "triple",
	"speedmod": 1.8
	},
	{
	"name": "quad",
	"speedmod": 2.19
	},
	{
	"name": "burst",
	"speedmod": 2.3
	}
]

func _ready() -> void:
	match get_meta("id"):
		"normalspeedportal":
			speed = SPEEDS.NORMAL
		"doublespeedportal":
			speed = SPEEDS.DOUBLE
		"triplespeedportal":
			speed = SPEEDS.TRIPLE
		"quadspeedportal":
			speed = SPEEDS.QUAD
		"slowspeedportal":
			speed = SPEEDS.SLOW
		"burstspeedportal":
			speed = SPEEDS.BURST

	$sprites.play(speedinfo[speed]["name"])

func _on_area_2d_area_entered(area) -> void:
	area = area.get_parent()
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
	var og = modulate
	tween.tween_property(self, "modulate", Color(2,2,2,2), 0.1).set_ease(Tween.EASE_IN)
	tween.tween_property(self, "modulate", og, 0.4).set_ease(Tween.EASE_OUT)
	await tween.finished
