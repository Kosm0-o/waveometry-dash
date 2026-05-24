extends Node2D

var data : Dictionary = {
	"angle": null,
	"gamemode": null,
	"dual": null,
	"speedmod": null,
	"trail_points": null
}
@onready var anim: AnimatedSprite2D = $AnimatedSprite2D
var time : float = 0.0


func _ready() -> void:
	global.all_checkpoints.append(self)

func _process(delta: float) -> void:
	if not global.lowdetailmode:
		anim.play("3d")
	elif global.lowdetailmode:
		anim.play("2d")
		time = 0.0
		scale.x = 1
	if not global.lowdetailmode:
		time += delta
		scale.x = sin(time * 10.0)
