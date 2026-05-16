extends Node2D
# WIP
enum ROTATIONS {NINETY, ONEEIGHTY}
@export var rot : ROTATIONS = ROTATIONS.NINETY
var rotationinfo : Array[Dictionary] = [
	{
	"name": "90",
	"color": Color("#e18b03"),
	"frontpos": Vector2(55.058, -28.302)
	},
	{
	"name": "180",
	"color": Color("#009dd9"),
	"frontpos": Vector2(50.341, -30.189)
	}
]

func _ready() -> void:
	$sprites.play(rotationinfo[rot]["name"])
	$particles.modulate = rotationinfo[rot]["color"]
	$sprites/fronthalf.position = rotationinfo[rot]["frontpos"]

func _on_area_2d_area_entered(area: Area2D) -> void:
	var additive : int = 90 if rot == ROTATIONS.NINETY else 180
	while global.rotation_tweening:
		await get_tree().create_timer(0.25).timeout
	await rotation_tween(global.layout_rotation + additive, additive)
	if global.layout_rotation >= 360:
		global.layout_rotation = 0
			

func rotation_tween(result : float, angle_add : int):
	global.rotation_tweening = true
	var tween = create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CUBIC)
	tween.tween_property(global, "layout_rotation", result, 0.5)
	await tween.finished
	global.rotation_tweening = false
