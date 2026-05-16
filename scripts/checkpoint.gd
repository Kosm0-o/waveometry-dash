extends Node2D

var data : Dictionary = {
	"angle": null,
	"gamemode": null,
	"dual": null,
	"speedmod": null,
	"trail_points": null
}

func _ready() -> void:
	global.all_checkpoints.append(self)
