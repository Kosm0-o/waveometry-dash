extends Line2D

var player : Player
@export var between_length : float = 10.0
@export var og_width : float = 21.0
var starter_frames : int = 250
const NEWFRAMES : int = 1
var frames : int = NEWFRAMES


var last_point_pos : Vector2 = Vector2.ZERO

func _ready() -> void:
	player = get_parent().player
	width = og_width
	await get_tree().process_frame
	last_point_pos = player.global_position
	add_point(last_point_pos)
	
func _process(delta: float) -> void:
	width = player.scale.x * og_width
	var pos = player.global_position
	
	starter_frames -= 1
	
	if pos.distance_squared_to(last_point_pos) >= pow(between_length, 2) or Input.is_action_just_pressed("click") or Input.is_action_just_released("click"):
		add_point(pos)
		last_point_pos = pos
		if starter_frames <= 0:
			frames -= 1
			if frames == 0:
				remove_point(0)
				frames = NEWFRAMES
	if points.size() > 0:
		points[points.size() - 1] = pos
