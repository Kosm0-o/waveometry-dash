extends Node

var mirror_tweening : bool = false
var dualing : bool = false
var exit_teleportals : Array[Teleportal] = []
var players : Array = []
var bounds : float = 630

# remember to change portal sprites in to 2 parts, front and back, for entering through illusion

func _process(delta: float) -> void:
	var pnode = get_tree().current_scene.get_node("players")
	if is_instance_valid(pnode):
		players = pnode.get_children()
