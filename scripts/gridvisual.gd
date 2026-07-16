extends Node2D

const GRID_SIZE : int = 89
const GRID_OFFSET : float = GRID_SIZE / 2.0

@onready var cam: Camera2D = $"../Camera2D"

func _draw() -> void:
	var viewport_size := get_viewport_rect().size

	# Visible size of the world
	var visible_width := viewport_size.x / cam.zoom.x
	var visible_height := viewport_size.y / cam.zoom.y

	var left := cam.global_position.x - visible_width * 0.5
	var right := cam.global_position.x + visible_width * 0.5
	var top := cam.global_position.y - visible_height * 0.5
	var bottom := cam.global_position.y + visible_height * 0.5

	# Snap to the nearest grid line before the visible area
	var start_x = floor((left - GRID_OFFSET) / GRID_SIZE) * GRID_SIZE + GRID_OFFSET
	var start_y = floor((top - GRID_OFFSET) / GRID_SIZE) * GRID_SIZE + GRID_OFFSET

	# Vertical lines
	var x = start_x
	while x <= right:
		draw_line(
			Vector2(x, top),
			Vector2(x, bottom),
			Color.WHITE
		)
		x += GRID_SIZE

	# Horizontal lines
	var y = start_y
	while y <= bottom:
		draw_line(
			Vector2(left, y),
			Vector2(right, y),
			Color.WHITE
		)
		y += GRID_SIZE
