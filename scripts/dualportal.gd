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
				await fade_tween(p, p.trail_node)
				p.trail_node.queue_free()
				p.queue_free()
				break
		global.dualing = false
	elif not global.dualing and dual == MODES.DUAL:
		var b = preload("res://scenes/player.tscn").instantiate()
		var c = preload("res://scenes/trail.tscn").instantiate()
		b.dual = true
		b.global_position = area.global_position
		if area.flux:
			b.flux = true
			b.dir = -1 * area.dir
		b.stairsmaster.active = area.stairsmaster.active
		b.ricochet.active = area.ricochet.active
		b.speedmod = area.speedmod
		b.ogspeedmod = area.ogspeedmod
		b.angle = area.angle
		b.trail_node = c
		c.player = b
		pnode.add_child(b)
		pnode.get_parent().add_child(c)
		global.dualing = true

func fade_tween(p : Player, t : Trail):
	var tween = create_tween().parallel().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CUBIC)
	tween.tween_property(p, "modulate:a", 0, 0.1)
	tween.tween_property(t, "modulate:a", 0, 0.1)
	await tween.finished
