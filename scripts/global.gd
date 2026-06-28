extends Node

signal portal_entered(portal)
signal died()

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
var practice_mode : bool = false
var all_checkpoints : Array = []
var object_defintions : Dictionary = {
	
}
var editor_selection : Resource
var current_lvl : Dictionary # unused for now 
var playtest : bool = false
var editing : bool = false
var selected_obj : LevelObject = null
var modes : Dictionary = {
	"selecting": true,
	"dragging": false,
	"adding": false,
	"deleting": false
}

func _ready() -> void:
	get_res_defs()

func _process(delta: float) -> void:
	xangle = layout_rotation == 0 or layout_rotation == 180
	yangle = layout_rotation == 90 or layout_rotation == 270
	if is_instance_valid(get_tree().current_scene):
		var pnode = get_tree().current_scene.get_node_or_null("Map")
		if pnode != null:
			pnode = pnode.get_node_or_null("players")
		if is_instance_valid(pnode):
			players = pnode.get_children()

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ldm"):
		lowdetailmode = not lowdetailmode
		complete_details = false

func get_res_defs():
	var fname = "res://Resources/objectdefs/"
	var folder = DirAccess.open(fname)
	for file in folder.get_files():
		if file.ends_with(".tres"):
			var def = load(fname + file)
			object_defintions[def.id] = def
