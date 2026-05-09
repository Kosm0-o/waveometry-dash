extends Node

var mirror_tweening : bool = false
var dualing : bool = false
var exit_teleportals : Array[Teleportal] = []
var players : Array = []

# remember to change portal sprites in to 2 parts, front and back, for entering through illusion

func _process(delta: float) -> void:
	players = get_tree().current_scene.get_node("players").get_children()
