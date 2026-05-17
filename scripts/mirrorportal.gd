extends Node2D

enum FLIPS {NORMAL, BACKWARD}
@export var flip : FLIPS = FLIPS.BACKWARD
var mirrorinfo : Array[Dictionary] = [
	{
	"name": "normal",
	"color": Color("#009dd9")
	},
	{
	"name": "backwards",
	"color": Color("#e18b03")
	}
]

func _ready() -> void:
	$sprites.play(mirrorinfo[flip]["name"])
	$particles.modulate = mirrorinfo[flip]["color"]
	$boop.modulate = mirrorinfo[flip]["color"]
	$boop.modulate.a = 2

func _on_area_2d_area_entered(area: Area2D) -> void:
	$boop.emitting = true
	while global.mirror_tweening:
		await get_tree().process_frame
	var cam = get_tree().current_scene.cam
	if flip == FLIPS.NORMAL:
		if sign(cam.zoom.x) == -1:
			cam_tween(cam, cam.zoom.x * -1)
	elif flip == FLIPS.BACKWARD:
		if sign(cam.zoom.x) == 1:
			cam_tween(cam, cam.zoom.x * -1)
			

func cam_tween(cam, result : float):
	global.mirror_tweening = true
	var tween = create_tween()#.set_ease(Tween.EASE_IN)
	tween.tween_property(cam, "zoom:x", result, 0.4)
	await tween.finished
	global.mirror_tweening = false
