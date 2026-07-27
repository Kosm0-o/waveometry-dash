extends Node

var song_definitions : Array[SongResource] = [
	
]

func _ready() -> void: 
	get_res_defs()

func get_res_defs():
	var fname = "res://Resources/songdefs/"
	var folder = DirAccess.open(fname)
	for file in folder.get_files():
		if file.ends_with(".tres"):
			var def = load(fname + file)
			if song_definitions.has(def):
				push_error(
					"Duplicate object id '%s'\nOld: %s\nNew: %s"
					% [def.id,
					song_definitions[def.id].resource_path,
					def.resource_path]
				)
				continue
			song_definitions.append(def)

func get_song(song_id : String):
	if song_id == "":
		song_id = "flow"
	for i in range(song_definitions.size()):
		if song_id == SongDatabase.song_definitions[i].id:
			return {"song_data": SongDatabase.song_definitions[i], "index": i}
