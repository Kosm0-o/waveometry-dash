extends Node2D

enum FLIPS {NORMAL, BACKWARD}
@export var flip : FLIPS = FLIPS.BACKWARD
var textures : Array[Texture2D] = [
	load("res://assets/normal mirror portal.svg"),
	load("res://assets/flipped mirror portal.svg")
]

func _ready() -> void:
	$Sprite2D.texture = textures[flip]

func _on_area_2d_area_entered(area: Area2D) -> void:
	var cam = get_tree().current_scene.cam
	if flip == FLIPS.NORMAL:
		if sign(cam.zoom.x) == -1:
			cam_tween(cam, cam.zoom.x * -1)
	elif flip == FLIPS.BACKWARD:
		if sign(cam.zoom.x) == 1:
			cam_tween(cam, cam.zoom.x * -1)
			

func cam_tween(cam, result : float):
	var tween = create_tween()
	tween.tween_property(cam, "zoom:x", result, 0.25)
	await tween.finished
