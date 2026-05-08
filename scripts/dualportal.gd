extends Node2D

enum MODES {DUAL, SINGLE}
@export var dual : MODES = MODES.DUAL
var textures : Array[Texture2D] = [
	load("res://assets/dual portal sprite.svg"),
	load("res://assets/single portal sprite.svg")
]
var colors : Array[Color] = [
	Color("#e18b03"),
	Color("#009dd9")
]
@onready var pnode : Node2D = get_tree().current_scene.get_node("players")

func _ready() -> void:
	$Sprite2D.texture = textures[dual]
	$particles.modulate = colors[dual]

func _on_area_2d_area_entered(area: Area2D) -> void:
	if global.dualing and dual == MODES.SINGLE:
		for p in pnode.get_children():
			if p.dual:
				p.trail_node.queue_free()
				p.queue_free()
				break
		global.dualing = false
	elif not global.dualing and dual == MODES.DUAL:
		var b = preload("res://scenes/player.tscn").instantiate()
		var c = preload("res://scenes/trail.tscn").instantiate()
		b.dual = true
		b.global_position = area.global_position
		c.player = b
		pnode.add_child(b)
		pnode.get_parent().add_child(c)
		global.dualing = true
