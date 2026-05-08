extends Line2D

@export var player : Player
@export var between_length : float = 10.0
@export var og_width : float = 21.0

var last_point_pos : Vector2 = Vector2.ZERO

func _ready() -> void:
	player.trail_node = self
	width = og_width
	await get_tree().process_frame
	last_point_pos = player.global_position
	add_point(last_point_pos)
	
func _process(delta: float) -> void:
	width = player.scale.x * og_width
	var pos = player.global_position
	
	if pos.distance_squared_to(last_point_pos) >= pow(between_length, 2) or Input.is_action_just_pressed("click") or Input.is_action_just_released("click"):
		add_point(pos)
		last_point_pos = pos
	
	points[points.size() - 1] = pos
