extends Node2D

@onready var cam: Camera2D = $Camera2D
@onready var editorvbox: VBoxContainer = $gui/editorscroll/VBoxContainer


var drag_offset : Vector2 = Vector2.ZERO


func _ready() -> void:
	global.editing = true
	LevelLoader.load_level("user://levelname.json", $levelobjects)
	var vals = global.object_defintions.values()
	var hboxes = editorvbox.get_children()
	for i in range(vals.size()):
		var def = vals[i]
		if def != null:
			var btn = Button.new()
			btn.text = def.display_name
			btn.pressed.connect((func(d : Resource): global.editor_selection = d).bind(def))
			hboxes[i % 3].add_child(btn)
	var c = 0
	for mode in $gui/modes.get_children():
		if not mode is Button: continue
		mode.pressed.connect(_change_mode.bind(c))
		c += 1

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("zoomin"):
		cam.zoom += Vector2.ONE * delta * 25 * cam.zoom.x
	if Input.is_action_just_pressed("zoomout"):
		cam.zoom -= Vector2.ONE * delta * 25 * cam.zoom.x

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("click"):
		if global.editor_selection != null and global.modes.adding:
			if global.editor_selection.scene != null: create_object()
		elif global.modes.dragging:
			if global.selected_obj != null: drag_offset = global.selected_obj.global_position - get_global_mouse_position()
	elif event is InputEventMouseMotion and Input.is_action_pressed("click") and global.modes.dragging:
		if global.selected_obj != null: global.selected_obj.global_position = get_global_mouse_position() + drag_offset

func _input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		if Input.is_action_pressed("rightclick") and event is InputEventMouseMotion:
			cam.position -= event.relative * 3

func create_object():
	var object = global.editor_selection.scene.instantiate()
	object.set_meta("id", global.editor_selection.id)
	$levelobjects.add_child(object)
	object.global_position = get_global_mouse_position()


func _on_playtest_pressed() -> void:
	global.playtest = true
	LevelLoader.save_level("user://levelname.json", $levelobjects)
	get_tree().change_scene_to_file("res://scenes/game.tscn")

func _change_mode(mode : int):
	var i = 0
	for key in global.modes:
		global.modes[key] = i == mode
		i += 1
		
