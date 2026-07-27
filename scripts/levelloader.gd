extends Node2D

func get_level_data(objects_node : Node2D, settings_dictionary : Dictionary):
	var level_data : Dictionary = {
		"level_name": settings_dictionary.get("level_name"),
		"objects": [],
		"gridsnap_enabled": settings_dictionary.get("gridsnap_enabled", false),
		"grid_enabled": settings_dictionary.get("grid_visual_enabled", false),
		"song_id": settings_dictionary.get("song_id", "timeleaper"),
		"song_start_time": settings_dictionary.get("song_start_time", 0.0),
		"start_speed": settings_dictionary.get("start_speed", "normal"),
		"glow_enabled": settings_dictionary.get("glow_enabled", true)
	}
	for obj in objects_node.get_children():
		level_data.objects.append({
			"id": obj.get_meta("id"), 
			"x": obj.global_position.x, 
			"y": obj.global_position.y, 
			"group_ids": obj.group_ids, 
			"targets": obj.targets, 
			"mod": obj.mod.to_html(true), 
			"rotation": obj.rotation_degrees,
			"scale_x": obj.scale.x,
			"scale_y": obj.scale.y,
			"zindex": obj.z_index,
			"target_color": obj.targ_color.to_html(true),
			"duration": obj.duration,
			"move_x": obj.move_x,
			"move_y": obj.move_y,
			"targ_rot": obj.targ_rot,
			"targ_scale_x": obj.targ_scale_x,
			"targ_scale_y": obj.targ_scale_y,
			"objecttext": obj.objecttext,
			"font_size": obj.font_size
			})
	return level_data

func save_level(path : String, objects_node : Node2D, settings_dictionary : Dictionary):
	var json = JSON.stringify(get_level_data(objects_node, settings_dictionary), "\t")
	var file = FileAccess.open(path, FileAccess.WRITE)
	file.store_string(json)
	file.close()

func load_level(path : String, objects_node : Node2D):
	for o in objects_node.get_children():
		objects_node.remove_child(o)
		o.queue_free()
	global.exit_teleportals.clear()
	var txt = FileAccess.get_file_as_string(path)
	var data = JSON.parse_string(txt)
	if data == null:
		push_error("Invalid lvl file bruh")
		return
	for obj_data in data.objects:
		spawn_obj(obj_data, objects_node)
	rebuild_groups(objects_node)
	return data

func spawn_obj(data : Dictionary, parent : Node2D):
	var def = EditorGlobal.object_defintions.get(data.id)
	if def == null:
		push_warning("Object isnt in da database: " + data.id)
		return
	var obj = def.scene.instantiate()
	obj.set_meta("id", data.id)
	parent.add_child(obj)
	obj.global_position = Vector2(data.x, data.y)
	obj.group_ids.clear()
	
	for id in data.group_ids:
		obj.group_ids.append(int(id))
	
	obj.targets.clear()
	for id in data.targets:
		obj.targets.append(int(id))
	
	obj.mod = Color(data.mod)
	obj.modulate = obj.mod
	obj.rotation_degrees = data.rotation
	obj.scale = Vector2(data.scale_x, data.scale_y)
	obj.z_index = data.zindex
	obj.targ_color = Color(data.target_color)
	obj.duration = data.duration
	obj.move_x = data.move_x
	obj.move_y = data.move_y
	obj.targ_rot = data.targ_rot
	obj.targ_scale_x = data.targ_scale_x
	obj.targ_scale_y = data.targ_scale_y
	obj.objecttext = data.objecttext
	obj.font_size = data.font_size

func rebuild_groups(objects_node : Node2D):
	EditorGlobal.groups.clear()
	for obj in objects_node.get_children():
		for id in obj.group_ids:
			if not EditorGlobal.groups.has(id):
				EditorGlobal.groups[id] = []
			EditorGlobal.groups[id].append(obj)
