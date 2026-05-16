extends Node2D

enum MODES {DUAL, SINGLE}
@export var dual : MODES = MODES.DUAL
var dualinfo : Array[Dictionary] = [
	{
	"name": "dual",
	"color": Color("#e18b03"),
	"mainpos": Vector2(30, -72),
	"frontpos": Vector2(-14.151, 19.811)
	},
	{
	"name": "single",
	"color": Color("#009dd9"),
	"mainpos": Vector2(9, -54),
	"frontpos": Vector2(12.3, -2.831)
	}
]

@onready var pnode : Node2D = get_tree().current_scene.get_node("Map").get_node("players")

func _ready() -> void:
	$sprites.play(dualinfo[dual]["name"])
	$particles.modulate = dualinfo[dual]["color"]
	$sprites.position = dualinfo[dual]["mainpos"]
	$sprites/fronthalf.position = dualinfo[dual]["frontpos"]

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
