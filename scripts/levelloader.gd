extends Node2D


func get_level_data(objects_node : Node2D):
	var level_data : Dictionary = {
		"name": "LevelName",
		"objects": []
	}
	
	for obj in objects_node.get_children():
		level_data.objects.append({"id": obj.get_meta("id"), "x": obj.global_position.x, "y": obj.global_position.y})
	return level_data

func save_level(path : String, objects_node : Node2D):
	var json = JSON.stringify(get_level_data(objects_node), "\t")
	var file = FileAccess.open(path, FileAccess.WRITE)
	file.store_string(json)
	file.close()

func load_level(path : String, objects_node : Node2D):
	for o in objects_node.get_children():
		o.queue_free()
	var txt = FileAccess.get_file_as_string(path)
	var data = JSON.parse_string(txt)
	if data == null:
		push_error("Invalid lvl file bruh")
		return
	for obj_data in data.objects:
		spawn_obj(obj_data, objects_node)
	return data

func spawn_obj(data : Dictionary, parent : Node2D):
	var def = global.object_defintions.get(data.id)
	if def == null:
		push_warning("Object isnt in da database: " + data.id)
		return
	var obj = def.scene.instantiate()
	obj.set_meta("id", data.id)
	parent.add_child(obj)
	obj.global_position = Vector2(data.x, data.y)
	
