extends Node

var mirror_tweening : bool = false
var dualing : bool = false
var exit_teleportals : Array[Teleportal] = []
var players : Array = []

func _process(delta: float) -> void:
	players = get_tree().current_scene.get_node("players").get_children()
