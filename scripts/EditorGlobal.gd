extends Node

signal object_deleted(object : LevelObject)

var object_defintions : Dictionary = {
	"backwardmirrorportal": load("res://Resources/objectdefs/backwardmirrorportal.tres"),
	"bgcolortrigger": load("res://Resources/objectdefs/bgcolortrigger.tres"),
	"block": load("res://Resources/objectdefs/block.tres"),
	"blueorb": load("res://Resources/objectdefs/blueorb.tres"),
	"bluepad": load("res://Resources/objectdefs/bluepad.tres"),
	"burstspeedportal": load("res://Resources/objectdefs/burstspeedportal.tres"),
	"circledeco": load("res://Resources/objectdefs/circledeco.tres"),
	"colortrigger": load("res://Resources/objectdefs/colortrigger.tres"),
	"dashorb": load("res://Resources/objectdefs/dashorb.tres"),
	"dblock": load("res://Resources/objectdefs/dblock.tres"),
	"doublespeedportal": load("res://Resources/objectdefs/doublespeedportal.tres"),
	"downgravityportal": load("res://Resources/objectdefs/downgravityportal.tres"),
	"droporb": load("res://Resources/objectdefs/droporb.tres"),
	"dualportal": load("res://Resources/objectdefs/dualportal.tres"),
	"enterteleportal": load("res://Resources/objectdefs/enterteleportal.tres"),
	"exitteleportal": load("res://Resources/objectdefs/exitteleportal.tres"),
	"flatspike": load("res://Resources/objectdefs/flatspike.tres"),
	"flipgravityportal": load("res://Resources/objectdefs/flipgravityportal.tres"),
	"fluxgamemodeportal": load("res://Resources/objectdefs/fluxgamemodeportal.tres"),
	"glowdeco": load("res://Resources/objectdefs/glowdeco.tres"),
	"linedeco": load("res://Resources/objectdefs/linedeco.tres"),
	"megasizeportal": load("res://Resources/objectdefs/megasizeportal.tres"),
	"minisizeportal": load("res://Resources/objectdefs/minisizeportal.tres"),
	"movetrigger": load("res://Resources/objectdefs/movetrigger.tres"),
	"normalgamemodeportal": load("res://Resources/objectdefs/normalgamemodeportal.tres"),
	"normalmirrorportal": load("res://Resources/objectdefs/normalmirrorportal.tres"),
	"normalsizeportal": load("res://Resources/objectdefs/normalsizeportal.tres"),
	"normalspeedportal": load("res://Resources/objectdefs/normalspeedportal.tres"),
	"pinkdashorb": load("res://Resources/objectdefs/pinkdashorb.tres"),
	"pinkorb": load("res://Resources/objectdefs/pinkorb.tres"),
	"pinkpad": load("res://Resources/objectdefs/pinkpad.tres"),
	"quadspeedportal": load("res://Resources/objectdefs/quadspeedportal.tres"),
	"quartercircledeco": load("res://Resources/objectdefs/quartercircledeco.tres"),
	"redorb": load("res://Resources/objectdefs/redorb.tres"),
	"redpad": load("res://Resources/objectdefs/redpad.tres"),
	"ricochetgamemodeportal": load("res://Resources/objectdefs/ricochetgamemodeportal.tres"),
	"rotationtrigger": load("res://Resources/objectdefs/rotationtrigger.tres"),
	"saw": load("res://Resources/objectdefs/saw.tres"),
	"scaletrigger": load("res://Resources/objectdefs/scaletrigger.tres"),
	"semicircledeco": load("res://Resources/objectdefs/semicircledeco.tres"),
	"singleportal": load("res://Resources/objectdefs/singleportal.tres"),
	"slowspeedportal": load("res://Resources/objectdefs/slowspeedportal.tres"),
	"spiderorb": load("res://Resources/objectdefs/spiderorb.tres"),
	"spiderpad": load("res://Resources/objectdefs/spiderpad.tres"),
	"spike": load("res://Resources/objectdefs/spike.tres"),
	"squaredeco": load("res://Resources/objectdefs/squaredeco.tres"),
	"stairsmastergamemodeportal": load("res://Resources/objectdefs/stairsmastergamemodeportal.tres"),
	"startpos": load("res://Resources/objectdefs/startpos.tres"),
	"textobject": load("res://Resources/objectdefs/textobject.tres"),
	"timothy": load("res://Resources/objectdefs/timothy.tres"),
	"triangledeco": load("res://Resources/objectdefs/triangledeco.tres"),
	"triplespeedportal": load("res://Resources/objectdefs/triplespeedportal.tres"),
	"upgravityportal": load("res://Resources/objectdefs/upgravityportal.tres"),
	"yelloworb": load("res://Resources/objectdefs/yelloworb.tres"),
	"yellowpad": load("res://Resources/objectdefs/yellowpad.tres")
}
var custom_objects : Dictionary
var editor_selection : Resource

var current_lvl = null
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
var custom_levels : Array = [
	
]

func _ready() -> void:
	var dir = DirAccess.open("user://")
	if not dir.dir_exists("customlevels"):
		dir.make_dir_recursive("customlevels")
	#get_res_defs()
	get_custom_levels()

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
	for id in object_defintions:
		print('"', id, '": load("', object_defintions[id].resource_path, '"),')

func get_custom_levels():
	var fname = "user://customlevels/"
	var folder = DirAccess.open(fname)
	for file in folder.get_files():
		if file.ends_with(".json"):
			custom_levels.append(fname + file)
