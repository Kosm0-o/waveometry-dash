extends LevelObject
class_name Teleportal

enum PORTALS {ENTRANCE, EXIT}
@export var portal : PORTALS = PORTALS.ENTRANCE
var teleportinfo : Array[Dictionary] = [
	{
	"name": "entrance",
	"color": Color("#009dd9")
	},
	{
	"name": "exit",
	"color": Color("#e18b03")
	}
]

var teledata : Dictionary = {}

func object_ready() -> void:
	match get_meta("id"):
		"enterteleportal":
			portal = PORTALS.ENTRANCE
		"exitteleportal":
			portal = PORTALS.EXIT
	if portal == PORTALS.EXIT:
		if not EditorGlobal.editing:
			global.exit_teleportals.append(self)
			global.exit_teleportals.shuffle()
		scale.x = -1
		group_bools["targets"] = false
	else:
		single_target = true
	$sprites.play(teleportinfo[portal]["name"])
	$particles.modulate = teleportinfo[portal]["color"]
	$boop.modulate = teleportinfo[portal]["color"]
	$boop.modulate.a = 2

	
func _on_area_2d_area_entered(area) -> void:
	area = area.get_parent()
	$boop.emitting = true
	if portal == PORTALS.ENTRANCE:
		var target_id = -1
		if not targets.is_empty():
			target_id = targets.front()
		if target_id != -1:
			for t in global.exit_teleportals:
				if target_id in t.group_ids:
					area.global_position = t.global_position - Vector2(50, 0)
					global.portal_entered.emit(t)
					break
		area.trail_node.reset()
