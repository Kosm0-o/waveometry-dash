extends Node2D

@onready var cam: Camera2D = $Camera2D
@onready var editorvbox: VBoxContainer = $gui/editorscroll/editorvbox

@onready var groupidnumglobal: SpinBox = $gui/groupsui/globalgroupspanel/groupid
@onready var identer: TextEdit = $gui/groupsui/groupspanel/btns/identer
@onready var rotationlbl: LineEdit = $gui/propertiesui/propertiespanel/ScrollContainer/org/HSlider/rotationlbl
@onready var xscalelbl: LineEdit = $gui/propertiesui/propertiespanel/ScrollContainer/org/scales/xslider/scalelbl
@onready var yscalelbl: LineEdit = $gui/propertiesui/propertiespanel/ScrollContainer/org/scales/yslider/scalelbl
@onready var xmovelbl: LineEdit = $gui/propertiesui/propertiespanel/ScrollContainer/org/distances/movex/movelbl
@onready var ymovelbl: LineEdit = $gui/propertiesui/propertiespanel/ScrollContainer/org/distances/movey/movelbl
@onready var durationedit: LineEdit = $gui/propertiesui/propertiespanel/ScrollContainer/org/durationedit
@onready var targrotlbl: LineEdit = $gui/propertiesui/propertiespanel/ScrollContainer/org/targrotslider/targrotlbl
@onready var grid: Node2D = $grid

var old_txt : Dictionary = {
	"id": "",
	"rotation": "",
	"xscale": "",
	"yscale": "",
	"duration": "",
	"xmove": "",
	"ymove": "",
	"targ_rot": "",
	}

var object_btns : Dictionary = {}
var object_counts : Dictionary = {}
var drag_offsets : Array[Vector2] = []
var clicked_obj : LevelObject = null #onframe
var cur_group_type : int = 2 # 2 for groups, 1 for targets
var group_rows : Dictionary = {}
const TOOL_KEY_MAPPING : Array = [
	"selecttool",
	"dragtool",
	"addtool",
	"deletetool"
	]

var hold_timer : float = 0.0
var threshold : float = 0.1
var drag_start_pos : Vector2 = Vector2.ZERO
var cur_rect : Rect2 = Rect2(0,0,0,0)
var min_max_x : Array = [null, null]
var updating_properties : bool = false
const GRIDSIZE : int = 89
var gridsnap : bool = false


func _ready() -> void:
	#LevelLoader.save_level("user://levelname.json", $levelobjects)
	EditorGlobal.editing = true
	var lvl_data = LevelLoader.load_level("user://levelname.json", $levelobjects)
	$gui/groupsui/globalgroupspanel/groupid.get_line_edit().add_theme_constant_override("minimum_character_width", 13)
	EditorGlobal.objects_selected.clear()
	connect_signals()
	re_group_lookup()
	re_obj_counts()
	recalibrate_level_slider()
	create_helper_trail()
	$gui/propertiesui/propertiespanel/ScrollContainer/org/modulate.modulate.a = 1.35638298
	$gui/propertiesui/propertiespanel/ScrollContainer/org/targetcolor.modulate.a = 1.35638298

func _process(delta: float) -> void:
	var hovered = get_viewport().gui_get_hovered_control()
	if hovered == null and not $gui/propertiesui/propertiespanel/ScrollContainer/org/modulate.get_popup().visible and not $gui/levelslider.has_focus() and not $gui/propertiesui/propertiespanel/ScrollContainer/org/targetcolor.get_popup().visible:
		if Input.is_action_just_pressed("zoomin"):
			cam.zoom += Vector2.ONE * delta * 25 * cam.zoom.x
			grid.queue_redraw()
		elif Input.is_action_just_pressed("zoomout"):
			cam.zoom -= Vector2.ONE * delta * 25 * cam.zoom.x
			grid.queue_redraw()
		cam.zoom = clamp(cam.zoom, Vector2(0.01,0.01), Vector2(50.0,50.0))
		if Input.is_action_pressed("editor_click") and (EditorGlobal.modes.deleting or EditorGlobal.modes.selecting):
			hold_timer += delta
			if hold_timer >= threshold:
				if drag_start_pos == Vector2.ZERO:
					clear_selected()
					drag_start_pos = get_global_mouse_position()
				cur_rect = get_drag_rect()
	if Input.is_action_just_released("editor_click"):
		grid.queue_redraw()
		recalibrate_level_slider()
		if hold_timer >= threshold:
			clear_selected()
			for obj in $levelobjects.get_children():
				if cur_rect.intersects(obj.get_editor_rect()):
					if EditorGlobal.modes.deleting:
						if EditorGlobal.object_defintions[obj.get_meta("id")].max_amount > 0: _object_deleted(obj)
						obj.queue_free()
					if EditorGlobal.modes.selecting:
						if not obj in EditorGlobal.objects_selected:
							EditorGlobal.objects_selected.append(obj)
							obj.modulate = Color(0.5, 1.5, 1.5, 1.5)
							EditorGlobal.selected_obj = obj
		hold_timer = 0.0
		drag_start_pos = Vector2.ZERO
		cur_rect = Rect2(0,0,0,0)
		queue_redraw()
	if EditorGlobal.modes.adding:
		create_pre_image()
	else:
		if EditorGlobal.preimage != null: EditorGlobal.preimage.queue_free()
		EditorGlobal.preimage = null
	$gui/groupsui/groupsbtn.visible = EditorGlobal.selected_obj != null and EditorGlobal.objects_selected.size() == 1
	$gui/propertiesbtn.visible = EditorGlobal.selected_obj != null and EditorGlobal.objects_selected.size() == 1

func connect_signals():
	EditorGlobal.object_deleted.connect(_object_deleted)
	$gui/editortabs.tab_changed.connect(generate_buttons)
	var c = 0
	for mode in $gui/modes.get_children():
		if not mode is Button: continue
		mode.pressed.connect(_change_mode.bind(c))
		c += 1
	for obj in $levelobjects.get_children():
		obj.object_clicked.connect(_object_selected)
	$gui/groupsui/groupsbtn.pressed.connect(
		func(): 
			$gui/groupsui/groupspanel.visible = true
			var g = EditorGlobal.selected_obj.group_ids if cur_group_type == 2 else EditorGlobal.selected_obj.targets
			referesh_group_ui(g)
			$gui/groupsui/groupspanel/groupscategories.set_tab_disabled(2, !EditorGlobal.selected_obj.group_bools["groups"])
			$gui/groupsui/groupspanel/groupscategories.set_tab_disabled(1, !EditorGlobal.selected_obj.group_bools["targets"])
			$gui/groupsui/groupspanel/groupscategories.current_tab = 2
			)
	$gui/propertiesbtn.pressed.connect(
		func():
			updating_properties = true
			$gui/propertiesui/propertiespanel.visible = true
			var obj = EditorGlobal.selected_obj
			rotationlbl.text = str(obj.rotation_degrees)
			xscalelbl.text = str(abs(obj.scale.x))
			yscalelbl.text = str(obj.scale.y)
			$gui/propertiesui/propertiespanel/ScrollContainer/org/HSlider.value = obj.rotation_degrees
			$gui/propertiesui/propertiespanel/ScrollContainer/org/scales/xslider.value = abs(obj.scale.x)
			$gui/propertiesui/propertiespanel/ScrollContainer/org/scales/yslider.value = obj.scale.y
			$gui/propertiesui/propertiespanel/ScrollContainer/org/modulate.color = obj.mod
			$gui/propertiesui/propertiespanel/ScrollContainer/org/zindexbox.value = int(obj.z_index)
			$gui/propertiesui/propertiespanel/ScrollContainer/org/fliplbl/fliptoggle.button_pressed = sign(obj.scale.x) == -1
			
			trigger_ui_check(obj)
			updating_properties = false
			)
	$gui/groupsui/groupspanel/btns/newgroupbtn.pressed.connect(_generate_group.bind(false))
	identer.text_changed.connect(_custom_group_check)
	rotationlbl.text_changed.connect(_rotation_check)
	rotationlbl.text_submitted.connect(func(txt): EditorGlobal.selected_obj.rotation_degrees = float(txt); $gui/propertiesui/propertiespanel/org/HSlider.value = float(txt))
	targrotlbl.text_changed.connect(_targ_rot_check)
	targrotlbl.text_submitted.connect(func(txt): EditorGlobal.selected_obj.targ_rot = float(txt); $gui/propertiesui/propertiespanel/ScrollContainer/org/targrotslider.value = float(txt))
	xscalelbl.text_changed.connect(_scale_check.bind(xscalelbl))
	xscalelbl.text_submitted.connect(func(txt): EditorGlobal.selected_obj.scale.x = float(txt) * sign(EditorGlobal.selected_obj.scale.x); $gui/propertiesui/propertiespanel/org/scales/xslider.value = float(txt))
	yscalelbl.text_changed.connect(_scale_check.bind(yscalelbl))
	yscalelbl.text_submitted.connect(func(txt): EditorGlobal.selected_obj.scale.y = float(txt); $gui/propertiesui/propertiespanel/org/scales/yslider.value = float(txt))
	xmovelbl.text_changed.connect(_move_check.bind(xmovelbl))
	xmovelbl.text_submitted.connect(func(txt): EditorGlobal.selected_obj.move_x = float(txt))
	ymovelbl.text_changed.connect(_move_check.bind(ymovelbl))
	ymovelbl.text_submitted.connect(func(txt): EditorGlobal.selected_obj.move_y = float(txt))
	$gui/groupsui/groupspanel/btns/addgroupbtn.pressed.connect(_generate_group.bind(true))
	$gui/groupsui/groupspanel/X.pressed.connect(func(): $gui/groupsui/groupspanel.visible = false)
	$gui/groupsui/globalgroupspanel/X.pressed.connect(func(): $gui/groupsui/groupspanel.visible = false; $gui/groupsui/globalgroupspanel.visible = false)
	$gui/groupsui/groupspanel/groupscategories.tab_selected.connect(_group_category_changed)
	$gui/groupsui/globalgroupspanel/btns/findgroupbtn.pressed.connect(_find_group_row)
	$gui/groupsui/globalgroupspanel/btns/selectallbtn.pressed.connect(_select_all_in_group)
	$gui/groupsui/globalgroupspanel/btns/deleteallbtn.pressed.connect(_delete_all_in_group)
	$gui/propertiesui/propertiespanel/ScrollContainer/org/HSlider.value_changed.connect(_rotation_value_changed)
	$gui/propertiesui/propertiespanel/ScrollContainer/org/scales/xslider.value_changed.connect(_scale_value_changed.bind("x"))
	$gui/propertiesui/propertiespanel/ScrollContainer/org/scales/yslider.value_changed.connect(_scale_value_changed.bind("y"))
	$gui/propertiesui/propertiespanel/X.pressed.connect(func(): $gui/propertiesui/propertiespanel.visible = false)
	$gui/propertiesui/propertiespanel/ScrollContainer/org/modulate.color_changed.connect(func(color): EditorGlobal.selected_obj.mod = color; EditorGlobal.selected_obj.modulate = color)
	$gui/propertiesui/propertiespanel/ScrollContainer/org/zindexbox.value_changed.connect(func(val : float): EditorGlobal.selected_obj.z_index = int(val))
	$gui/propertiesui/propertiespanel/ScrollContainer/org/fliplbl/fliptoggle.toggled.connect(func(on : bool): if not updating_properties: EditorGlobal.selected_obj.scale.x *= -1)
	$gui/levelslider.value_changed.connect(func(val : float): cam.position.x = val)
	$gui/levelslider.drag_ended.connect(func(changed): $gui/levelslider.release_focus())
	$gui/gridsnap/toggle.toggled.connect(func(toggle : bool): gridsnap = toggle)
	$gui/propertiesui/propertiespanel/ScrollContainer/org/targetcolor.color_changed.connect(func(color): EditorGlobal.selected_obj.targ_color = color)
	durationedit.text_changed.connect(_duration_check)
	durationedit.text_submitted.connect(func(txt): EditorGlobal.selected_obj.duration = float(txt))
	
func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("editor_click"):
		if EditorGlobal.editor_selection != null and EditorGlobal.modes.adding:
			if EditorGlobal.editor_selection.scene != null and get_viewport().gui_get_hovered_control() == null: create_object()
		elif EditorGlobal.modes.dragging:
			if EditorGlobal.selected_obj != null:
				drag_offsets.clear()
				for obj in EditorGlobal.objects_selected:
					drag_offsets.append(obj.global_position - get_global_mouse_position())
		elif EditorGlobal.modes.selecting:
			var obj = clicked_obj
			clicked_obj = null
			if obj == null:
				clear_selected()
	elif event is InputEventMouseMotion and Input.is_action_pressed("editor_click") and EditorGlobal.modes.dragging:
		if EditorGlobal.selected_obj != null:
			for i in range(EditorGlobal.objects_selected.size()):
				var pos = get_global_mouse_position() + drag_offsets[i]
				EditorGlobal.objects_selected[i].global_position = snap(pos) if gridsnap else pos
	if not EditorGlobal.objects_selected.is_empty():
		if event.is_action_pressed("delete"):
			var objs = []
			objs.append_array(EditorGlobal.objects_selected)
			clear_selected()
			for obj in objs:
				obj.queue_free()
		elif event.is_action_pressed("unselect"):
			clear_selected()
	if event.is_action_pressed("savelvl"):
		LevelLoader.save_level("user://levelname.json", $levelobjects)
		save_tween()
	elif event.is_action_pressed("duplicate"):
		duplicate_object()
	for input in TOOL_KEY_MAPPING:
		if event.is_action_pressed(input):
			_change_mode(TOOL_KEY_MAPPING.find(input))

func _input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		if Input.is_action_pressed("rightclick") and event is InputEventMouseMotion:
			cam.position -= event.relative * 3
			$gui/levelslider.value = cam.position.x
			grid.queue_redraw()


func create_object():
	var mx = EditorGlobal.editor_selection.max_amount
	var id = EditorGlobal.editor_selection.id
	if mx > 0:
		if object_counts.get(id, 0) >= mx:
			return
	var object = EditorGlobal.editor_selection.scene.instantiate()
	object.set_meta("id", EditorGlobal.editor_selection.id)
	$levelobjects.add_child(object)
	var ggms = get_global_mouse_position()
	object.global_position = snap(ggms) if gridsnap else ggms
	if mx > 0:
		upd_obj_count(id, 1)
	object.object_clicked.connect(_object_selected)
	recalibrate_level_slider()
	grid.queue_redraw()
	if EditorGlobal.preimage != null:
		EditorGlobal.preimage.queue_free()
		EditorGlobal.preimage = null


func _on_playtest_pressed() -> void:
	EditorGlobal.playtest = true
	LevelLoader.save_level("user://levelname.json", $levelobjects)
	get_tree().change_scene_to_file("res://scenes/game.tscn")

func _change_mode(mode : int):
	var i = 0
	for key in EditorGlobal.modes:
		EditorGlobal.modes[key] = i == mode
		i += 1
	var c
	var btn : Button
	if EditorGlobal.modes.selecting:
		c = Input.CURSOR_ARROW
		btn = $gui/modes/select
	elif EditorGlobal.modes.dragging:
		c = Input.CURSOR_DRAG
		btn = $gui/modes/drag
	elif EditorGlobal.modes.adding:
		c = Input.CURSOR_CROSS
		btn = $gui/modes/add
	elif EditorGlobal.modes.deleting:
		c = Input.CURSOR_FORBIDDEN
		btn = $gui/modes/delete
	Input.set_default_cursor_shape(c)
	for b in $gui/modes.get_children():
		b.modulate = Color.WHITE
	btn.modulate = Color.YELLOW
	
func _object_deleted(obj : LevelObject):
	upd_obj_count(obj.get_meta("id"), -1)

func upd_obj_count(id : String, remove : int):
	object_counts.set(id, object_counts.get(id, 0) + 1 * remove)
	update_btn(id)

func update_btn(id : String):
	var btn = object_btns.get(id)
	if btn == null: return
	var def = EditorGlobal.object_defintions[id]
	if def.max_amount < 1: return 
	btn.get("label").text = str(int(def.max_amount - object_counts[id])) + "/" + str(def.max_amount)
	
func generate_buttons(tabnum : int):
	var category = EditorGlobal.CATEGORIES[tabnum]
	var vals = EditorGlobal.object_defintions.values()
	var hboxes = editorvbox.get_children()
	for i in range(3):
		for child in hboxes[i].get_children(): child.queue_free()
	for i in range(vals.size()):
		var def = vals[i]
		if def.category != category: continue
		if def != null:
			var btn = Button.new()
			btn.text = def.display_name
			btn.set_meta("id", def.id)
			btn.pressed.connect((func(d : Resource): EditorGlobal.editor_selection = d).bind(def))
			hboxes[i % 3].add_child(btn)
			object_btns[def.id] = {"button": btn}
			if def.max_amount > 0:
				var lbl = Label.new()
				var settings = LabelSettings.new()
				settings.font_size = 13
				settings.outline_color = Color("#2e2e2e")
				settings.outline_size = 7
				lbl.text = str(int(def.max_amount - object_counts.get(def.id, 0))) + "/" + str(def.max_amount)
				lbl.label_settings = settings
				lbl.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
				lbl.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
				btn.add_child(lbl)
				lbl.size = btn.size
				lbl.position.y = 15.375
				object_btns[def.id] = {"button": btn, "label": lbl}

func re_obj_counts():
	for obj in $levelobjects.get_children():
		var id = obj.get_meta("id")
		object_counts[id] = object_counts.get(id, 0) + 1
	for id in object_btns:
		update_btn(id)

func re_group_lookup():
	EditorGlobal.groups.clear()
	for obj in $levelobjects.get_children():
		for id in obj.group_ids:
			if not EditorGlobal.groups.has(id):
				EditorGlobal.groups[id] = []
			EditorGlobal.groups[id].append(obj)

func recalibrate_level_slider():
	min_max_x = [null, null]
	for obj in $levelobjects.get_children():
		var xpos = obj.global_position.x
		if min_max_x.front() == null:
			min_max_x[0] = xpos
			min_max_x[1] = xpos
		if xpos < min_max_x.front():
			min_max_x[0] = xpos
		elif xpos > min_max_x.back():
			min_max_x[1] = xpos
	if min_max_x.front() == null:
		min_max_x = [0, 0]
	$gui/levelslider.min_value = min_max_x.front()
	$gui/levelslider.max_value = min_max_x.back()
	$gui/levelslider.step = (abs($gui/levelslider.min_value) + abs($gui/levelslider.max_value)) / 100

func _object_selected(obj : LevelObject):
	clicked_obj = obj
	clear_selected()
	EditorGlobal.objects_selected.append(obj)
	EditorGlobal.selected_obj = obj
	EditorGlobal.selected_obj.modulate = Color(0.5, 1.5, 1.5, 1.5)

func clear_selected():
	for obj in EditorGlobal.objects_selected:
		obj.modulate = obj.mod
	EditorGlobal.objects_selected.clear()
	EditorGlobal.selected_obj = null
	drag_offsets.clear()

func next_group_id(groups : Array):
	groups.sort()
	var id = 1
	for group in groups:
		if group != id:
			return id
		id += 1
	return id
	
func _generate_group(custom : bool):
	var obj = EditorGlobal.selected_obj
	var groups = EditorGlobal.groups.keys() if cur_group_type == 2 else obj.targets
	var id = int(identer.text) if custom else next_group_id(groups)
	if custom:
		identer.text = ""
		old_txt.id = ""
	if obj.group_ids.has(id):
		return
	if cur_group_type == 2:
		if not groups.has(id):
			EditorGlobal.groups[id] = []
		EditorGlobal.groups[id].append(obj)
	obj.add_group(id, cur_group_type == 2)
	referesh_group_ui(obj.group_ids if cur_group_type == 2 else obj.targets)
	

func referesh_group_ui(type):
	for ui in $gui/groupsui/groupspanel/idscroll/groupids.get_children():
		ui.queue_free()
	for group in type:
		_generate_group_visual(group)

func refresh_global_groups_ui():
	group_rows.clear()
	
	for row in $gui/groupsui/globalgroupspanel/rowscroll/vsep.get_children():
		row.queue_free()
		
	var ids = EditorGlobal.groups.keys()
	ids.sort()
	for id in ids:
		var newrow = preload("res://scenes/globalgrouprow.tscn").instantiate()
		$gui/groupsui/globalgroupspanel/rowscroll/vsep.add_child(newrow)
		newrow.groupnum.text = str(id)
		newrow.objectnum.text = str(EditorGlobal.groups[id].size())
		
		group_rows[id] = newrow
	
func _generate_group_visual(group_id : int):
	var cms = Vector2(114.9, 58.87)
	var btn = Button.new()
	btn.custom_minimum_size = cms
	btn.set("theme_override_styles/normal", load("res://Resources/visuals/groupid.tres"))
	btn.text = str(group_id)
	$gui/groupsui/groupspanel/idscroll/groupids.add_child(btn)
	btn.pressed.connect(_group_removal_check.bind(EditorGlobal.selected_obj, btn, group_id))

func _custom_group_check():
	if (identer.text.is_valid_int() or identer.text == "") and len(identer.text) <= 15:
		if int(identer.text) >= 0:
			old_txt.id = identer.text
	else:
		identer.text = old_txt.id
		identer.set_caret_column(len(identer.text))

func _rotation_check(txt : String):
	if (txt.is_valid_float() and float(txt) >= -360.0 and float(txt) <= 360.0) or txt == "":
		old_txt.rotation = txt
	else:
		rotationlbl.text = old_txt.rotation
		rotationlbl.set_caret_column(len(rotationlbl.text))

func _targ_rot_check(txt : String):
	if (txt.is_valid_float() and float(txt) >= -360.0 and float(txt) <= 360.0) or txt == "":
		old_txt.rotation = txt
	else:
		rotationlbl.text = old_txt.rotation
		rotationlbl.set_caret_column(len(rotationlbl.text))

func _duration_check(txt : String):
	if (txt.is_valid_float() and float(txt) >= 0.0) or txt == "":
		old_txt.duration = txt
		EditorGlobal.selected_obj.duration = float(txt)
	else:
		durationedit.text = old_txt.duration
		durationedit.set_caret_column(len(durationedit.text))


func _scale_check(txt : String, lineedit : LineEdit):
	if (txt.is_valid_float() and float(txt) >= 0.05 and float(txt) <= 25.0) or txt == "":
		if "x" in str(lineedit.get_parent().name):
			old_txt.xscale = txt
		else:
			old_txt.yscale = txt
	else:
		var old = old_txt.xscale if "x" in str(lineedit.get_parent().name) else old_txt.yscale
		lineedit.text = old
		lineedit.set_caret_column(len(lineedit.text))

func _move_check(txt : String, lineedit : LineEdit):
	if txt.is_valid_float()or txt == "":
		if "x" in str(lineedit.get_parent().name):
			old_txt.xmove = txt
			EditorGlobal.selected_obj.move_x = float(txt)
		else:
			old_txt.ymove = txt
			EditorGlobal.selected_obj.move_y = float(txt)
	else:
		var old = old_txt.xmove if "x" in str(lineedit.get_parent().name) else old_txt.ymove
		lineedit.text = old
		lineedit.set_caret_column(len(lineedit.text))

func _group_removal_check(obj : LevelObject, btn : Button, id : int):
	obj.remove_group(id, cur_group_type == 2)
	if cur_group_type == 2:
		EditorGlobal.groups[id].erase(obj)
		if EditorGlobal.groups[id].is_empty():
			EditorGlobal.groups.erase(id)
	btn.queue_free()
	var g = obj.group_ids if cur_group_type == 2 else obj.targets
	referesh_group_ui(g)

func _group_category_changed(tab : int):
	var tabname = $gui/groupsui/groupspanel/groupscategories.get_tab_title(tab)
	var newbtn = $gui/groupsui/groupspanel/btns/newgroupbtn
	var addbtn = $gui/groupsui/groupspanel/btns/addgroupbtn
	var lbl = $gui/groupsui/groupspanel/Label
	match tabname:
		"Groups":
			$gui/groupsui/groupspanel.visible = true
			newbtn.text = "New Group"
			addbtn.text = "Add Group"
			lbl.text = "Groups"
			$gui/groupsui/globalgroupspanel.visible = false
			
		"Targets":
			$gui/groupsui/groupspanel.visible = true
			newbtn.text = "New Target"
			addbtn.text = "Add Target"
			lbl.text = "Targets"
			$gui/groupsui/globalgroupspanel.visible = false
			
		"Global":
			$gui/groupsui/globalgroupspanel.visible = true
	
	cur_group_type = tab
	if tab > 0:
		var g = EditorGlobal.selected_obj.group_ids if cur_group_type == 2 else EditorGlobal.selected_obj.targets
		referesh_group_ui(g)
	else:
		refresh_global_groups_ui() 

func get_drag_rect():
	var mouse = get_global_mouse_position()
	var rect = Rect2(
		min(drag_start_pos.x, mouse.x),
		min(drag_start_pos.y, mouse.y),
		abs(mouse.x - drag_start_pos.x),
		abs(mouse.y - drag_start_pos.y),
	)
	queue_redraw()
	for obj in $levelobjects.get_children():
		if rect.intersects(obj.get_editor_rect()):
			if EditorGlobal.modes.deleting:
				obj.modulate = Color.RED
	return rect

func _draw() -> void:
	var color : Color
	if EditorGlobal.modes.deleting:
		color = Color(1.0, 0.0, 0.0, 0.3)
	elif EditorGlobal.modes.selecting:
		color = Color(0.25, 0.75, 2.0, 0.3)
	draw_rect(cur_rect, color)

func _find_group_row():
	var id = int(groupidnumglobal.value)
	if not group_rows.has(id): return
	var row = group_rows[id]
	scroll_tween(row.position.y, row)

func scroll_tween(y_pos : float, row):
	var tween = create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CUBIC)
	tween.tween_property($gui/groupsui/globalgroupspanel/rowscroll, "scroll_vertical", y_pos, 0.25)
	tween.parallel().tween_property(row, "modulate", Color.LIGHT_YELLOW + Color(10.0,10.0,10.0,10.0), 0.25).set_delay(0.1)
	tween.parallel().tween_property(row, "modulate", Color.WHITE, 0.25).set_delay(0.35)
	await tween.finished

func _select_all_in_group():
	var group = groupidnumglobal.value
	for id in EditorGlobal.groups:
		if id == group:
			clear_selected()
			for obj in EditorGlobal.groups[id]:
				if not obj in EditorGlobal.objects_selected:
					EditorGlobal.objects_selected.append(obj)
					obj.modulate = Color(0.5, 1.5, 1.5, 1.5)
					EditorGlobal.selected_obj = obj
			break

func _delete_all_in_group():
	var group = groupidnumglobal.value
	for id in EditorGlobal.groups:
		if id == group:
			for obj in EditorGlobal.groups[id]:
				_object_deleted(obj)
				obj.queue_free()
	EditorGlobal.groups.erase(int(group))
	refresh_global_groups_ui()

func _rotation_value_changed(val : float):
	rotationlbl.text = str(val)
	EditorGlobal.selected_obj.rotation_degrees = val

func _scale_value_changed(val : float, type : String):
	if type == "x":
		xscalelbl.text = str(val)
		EditorGlobal.selected_obj.scale.x = val * sign(EditorGlobal.selected_obj.scale.x)
	else:
		yscalelbl.text = str(val)
		EditorGlobal.selected_obj.scale.y = val
	

func create_pre_image():
	if EditorGlobal.preimage != null: EditorGlobal.preimage.queue_free();
	if EditorGlobal.editor_selection:
		var obj = EditorGlobal.editor_selection.scene.instantiate()
		obj.set_meta("id", EditorGlobal.editor_selection.id)
		$preimage.add_child(obj)
		obj.modulate.a = 0.5
		var ggms = get_global_mouse_position()
		obj.global_position = snap(ggms) if gridsnap else ggms
		EditorGlobal.preimage = obj

func create_helper_trail():
	if EditorGlobal.trail_points:
		var line = Line2D.new()
		$helperline.add_child(line)
		line.points = EditorGlobal.trail_points
		line.width = 5
		line.default_color = Color.WHITE

func duplicate_object():
	var og = EditorGlobal.selected_obj
	var obj = og.duplicate(Node.DUPLICATE_SCRIPTS | Node.DUPLICATE_SIGNALS | Node.DUPLICATE_USE_INSTANTIATION)
	var def = EditorGlobal.object_defintions[obj.get_meta("id")] 
	var mx = def.max_amount
	var id = def.id
	if mx > 0:
		if object_counts.get(id, 0) >= mx:
			return
	$levelobjects.add_child(obj)
	obj.global_position += Vector2.ONE * 100
	for gid in og.group_ids:
		EditorGlobal.groups[gid].append(obj)
		obj.add_group(gid, true)
	for targ in og.targets:
		obj.add_group(targ, false)
	clear_selected()
	EditorGlobal.objects_selected.append(obj)
	EditorGlobal.selected_obj = obj
	obj.object_clicked.connect(_object_selected)
	recalibrate_level_slider()

func snap(pos : Vector2):
	return Vector2(round(pos.x / GRIDSIZE) * GRIDSIZE, round(pos.y / GRIDSIZE) * GRIDSIZE)

func trigger_ui_check(obj : LevelObject):
	var custom_properties_uis : Array = [
		$gui/propertiesui/propertiespanel/ScrollContainer/org/targetcolorlbl,
		$gui/propertiesui/propertiespanel/ScrollContainer/org/targetcolor,
		$gui/propertiesui/propertiespanel/ScrollContainer/org/durationlbl,
		$gui/propertiesui/propertiespanel/ScrollContainer/org/durationedit,
		$gui/propertiesui/propertiespanel/ScrollContainer/org/distancelbl,
		$gui/propertiesui/propertiespanel/ScrollContainer/org/distances
	]
	for ui in custom_properties_uis:
		ui.visible = false
	
	var id = obj.get_meta("id")
	if "trigger" in id:
		$gui/propertiesui/propertiespanel/ScrollContainer/org/durationlbl.visible = true
		$gui/propertiesui/propertiespanel/ScrollContainer/org/durationedit.visible = true
		$gui/propertiesui/propertiespanel/ScrollContainer/org/durationedit.text = str(obj.duration)
	match id:
		"bgcolortrigger":
			$gui/propertiesui/propertiespanel/ScrollContainer/org/targetcolorlbl.visible = true
			$gui/propertiesui/propertiespanel/ScrollContainer/org/targetcolor.visible = true
			$gui/propertiesui/propertiespanel/ScrollContainer/org/targetcolor.color = obj.targ_color
		
		"movetrigger":
			$gui/propertiesui/propertiespanel/ScrollContainer/org/distancelbl.visible = true
			$gui/propertiesui/propertiespanel/ScrollContainer/org/distances.visible = true
			$gui/propertiesui/propertiespanel/ScrollContainer/org/distances/movex/movelbl.text = str(obj.move_x)
			$gui/propertiesui/propertiespanel/ScrollContainer/org/distances/movey/movelbl.text = str(obj.move_y)

func save_tween():
	var tween = create_tween().set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
	tween.tween_property($gui/savepanel, "global_position:y", 75, 0.35)
	tween.tween_property($gui/savepanel, "global_position:y", -142, 0.35).set_delay(0.5)
	await tween.finished
