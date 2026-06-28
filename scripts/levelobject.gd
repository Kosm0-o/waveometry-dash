extends Node2D
class_name LevelObject

var mouse_over : bool = false
var area : Area2D = null

func _notification(what: int) -> void:
	if what == NOTIFICATION_READY:
		for node in get_children():
			if node is Area2D and "clickdetector" in node.name:
				area = node
				break
		if area != null and not area.mouse_entered.is_connected(_mouse):
			area.mouse_entered.connect(_mouse.bind(true))
			area.mouse_exited.connect(_mouse.bind(false))

func _mouse(over: bool): mouse_over = over

func _input(event: InputEvent) -> void:
	pass

func _unhandled_input(event: InputEvent) -> void:
	if mouse_over and event.is_action_pressed("click") and global.modes.selecting:
		if global.selected_obj != null: global.selected_obj.modulate = Color.WHITE
		global.selected_obj = self
		modulate = Color(0.5, 1.5, 1.5, 1.5)
		if global.selected_obj != null: print("object selected: " + str(global.selected_obj))
	elif event.is_action_pressed("click") and global.modes.deleting and mouse_over:
		queue_free()
	elif event is InputEventMouseMotion:
		if global.modes.deleting:
			modulate = Color.RED if mouse_over else Color.WHITE
		elif global.modes.adding:
			modulate = Color.WHITE
