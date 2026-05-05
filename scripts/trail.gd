extends Line2D

@export var player : Player

func _ready() -> void:
	add_point(player.global_position)
	
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("click") or Input.is_action_just_released("click"):
		add_point(player.global_position)
	points[points.size() - 1] = Vector2(player.global_position)
