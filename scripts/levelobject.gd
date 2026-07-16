extends Node2D
class_name LevelObject

signal object_clicked(obj : LevelObject)

var mouse_over : bool = false
var clickarea : Area2D = null
@export var group_bools : Dictionary = {"groups": false, "targets": false}
var group_ids : Array[int] = []
var targets : Array[int] = []
var single_target : bool = false
var mod : Color = Color.WHITE
var targ_color : Color = Color.BLACK
var duration : float = 1.0
var move_x : float = 0.0
var move_y : float = 0.0
var targ_rot : float = 0.0

func _ready() -> void:
	click_detector_setup()
	group_bools = group_bools.duplicate(true)
	object_ready()

func click_detector_setup():
	for node in get_children():
		if node is Area2D and "clickdetector" in node.name:
			clickarea = node
			break
	if clickarea != null and not clickarea.mouse_entered.is_connected(_mouse):
		clickarea.mouse_entered.connect(_mouse.bind(true))
		clickarea.mouse_exited.connect(_mouse.bind(false))

func object_ready():
	pass
	

func _mouse(over: bool): mouse_over = over

func _unhandled_input(event: InputEvent) -> void:
	if not EditorGlobal.editing: return
	if event.is_action_pressed("editor_click") and EditorGlobal.modes.selecting and mouse_over:
		object_clicked.emit(self)
	elif event.is_action_pressed("editor_click") and EditorGlobal.modes.deleting and mouse_over:
		if EditorGlobal.object_defintions[get_meta("id")].max_amount > 0: EditorGlobal.object_deleted.emit(self)
		EditorGlobal.objects_selected.erase(self)
		queue_free()
	elif event is InputEventMouseMotion:
		if EditorGlobal.modes.deleting:
			modulate = Color.RED if mouse_over else mod
		elif EditorGlobal.modes.adding:
			modulate = mod

func add_group(id : int, type_is_group : bool):
	if type_is_group:
		if group_ids.has(id): return
		group_ids.append(id)
		group_ids.sort()
	else:
		if targets.has(id) or (single_target and targets.size() > 0):
			if single_target:
				$targetpopup.visible = true
				await get_tree().create_timer(1.0).timeout
				$targetpopup.visible = false
			return
		targets.append(id)
		targets.sort()
	
func remove_group(id : int, type_is_group : bool):
	if type_is_group:
		group_ids.erase(id)
	else:
		targets.erase(id)

func get_editor_rect():
	var col = clickarea.get_child(0)
	if col is CollisionShape2D:
		var shape = col.shape
		if shape is CircleShape2D:
			var radius = shape.radius
			var center = col.global_position
			var size = Vector2.ONE * radius * 2
			var pos = center - Vector2.ONE * radius
			return Rect2(pos, size)
		elif shape is CapsuleShape2D:
			var radius = shape.radius
			var height = shape.height
			var size = Vector2(radius * 2, height)
			var pos = Vector2(-radius, -height/2.0)
			return Rect2(pos, size)
		else:
			var extents = shape.size * 0.5
			return Rect2(global_position - extents, shape.size)
	elif col is CollisionPolygon2D:
		var rect = Rect2(0,0,0,0)
		for point in col.polygon:
			rect = rect.expand(point)
		rect.position += col.global_position
		return rect
