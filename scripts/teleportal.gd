extends Node2D
class_name Teleportal

enum PORTALS {ENTRANCE, EXIT}
@export var portal : PORTALS = PORTALS.ENTRANCE
var textures : Array[Texture2D] = [
	load("res://assets/enter teleportal sprite.svg"),
	load("res://assets/exit teleportal sprite.svg")
]
var colors : Array[Color] = [
	Color("#009dd9"),
	Color("#e18b03")
]
@onready var pnode : Node2D = get_tree().current_scene.get_node("players")
@export_category("ENTRANCE PORTAL ONLY")
@export var target_group_id : int
@export_category("EXIT PORTAL ONLY")
@export var group_id : int
@export var flipped : bool = false

var teledata : Dictionary = {}

func _ready() -> void:
	if portal == PORTALS.EXIT:
		global.exit_teleportals.append(self)
		global.exit_teleportals.shuffle()
		scale.x = -1 if flipped else 1
	$Sprite2D.texture = textures[portal]
	$particles.modulate = colors[portal]

func _on_area_2d_area_entered(area: Area2D) -> void:
	if portal == PORTALS.ENTRANCE:
		for t in global.exit_teleportals:
			if t.group_id == target_group_id:
				area.global_position = t.global_position
				break
