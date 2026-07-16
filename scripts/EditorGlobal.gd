extends Node

signal object_deleted(object : LevelObject)

var object_defintions : Dictionary = {
	
}
var custom_objects : Dictionary
var editor_selection : Resource

var current_lvl : Dictionary # unused for now 
var playtest : bool = false
var editing : bool = false
var objects_selected : Array[LevelObject] = []
var selected_obj : LevelObject = null
var modes : Dictionary = {
	"selecting": true,
	"dragging": false,
	"adding": false,
	"deleting": false
}
const CATEGORIES : Array = [
	"blocks",
	"hazards",
	"portals",
	"interactables",
	"deco",
	"triggers"
]
var groups : Dictionary = {
	
}
var preimage = null
var trail_points


func _ready() -> void:
	get_res_defs()

func get_res_defs():
	var fname = "res://Resources/objectdefs/"
	var folder = DirAccess.open(fname)
	for file in folder.get_files():
		if file.ends_with(".tres"):
			var def = load(fname + file)
			if object_defintions.has(def.id):
				push_error(
					"Duplicate object id '%s'\nOld: %s\nNew: %s"
					% [def.id,
					object_defintions[def.id].resource_path,
					def.resource_path]
				)
				continue
			object_defintions[def.id] = def
