extends Node

signal portal_entered(portal)

var mirror_tweening : bool = false
var rotation_tweening : bool = false
var dualing : bool = false
var exit_teleportals : Array[Teleportal] = []
var players : Array = []
var bounds : float = 630
var cam_offset : float
var lowdetailmode : bool = false
var complete_details : bool = false
var layout_rotation : float = 0.0 # in degrees
var xangle : bool = layout_rotation == 0 or layout_rotation == 180 # when you travel horizontally
var yangle : bool = layout_rotation == 90 or layout_rotation == 270 # when you travel vertically
var practice_mode : bool = true
var all_checkpoints : Array = []

# remember to change portal sprites in to 2 parts, front and back, for entering through illusion

func _process(delta: float) -> void:
	xangle = layout_rotation == 0 or layout_rotation == 180
	yangle = layout_rotation == 90 or layout_rotation == 270
	var pnode = get_tree().current_scene.get_node("Map").get_node("players")
	if is_instance_valid(pnode):
		players = pnode.get_children()

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ldm"):
		lowdetailmode = not lowdetailmode
		complete_details = false
