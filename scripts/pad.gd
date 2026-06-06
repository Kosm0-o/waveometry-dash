extends Area2D

enum PADS {YELLOW, PINK, RED, SPIDER, BLUE}
@export var pad : PADS = PADS.YELLOW

# negative boost = down, positive = up

var pad_data : Array = [
	{
		"name": "yellow",
		"boost": 5000
	},
	{
		"name": "pink",
		"boost": 2500
	},
	{
		"name": "red",
		"boost": 11500
	},
	{
		"name": "spider",
		"boost": 50000
	},
	{
		"name": "blue",
		"angle_mult": -1 
	}
]

@export_category("REVERSE DIRECTION")
@export var flipped : bool = false

var padded : bool = false

func _ready() -> void:
	pass

func _process(delta: float) -> void:
	if get_overlapping_bodies().size() > 0:
		_on_body_entered(get_overlapping_bodies().front())

func _on_body_entered(body: Node2D) -> void:
	if padded:
		return
	padded = true if not pad == PADS.SPIDER else false
	var m = -1 if flipped else 1
	match pad:
		PADS.SPIDER:
			body.dropping = true
			body.y_boost = pad_data[pad].boost * m
		
		PADS.YELLOW, PADS.PINK, PADS.RED:
			body.y_boost = pad_data[pad].boost * sign(body.angle)
			
		PADS.BLUE:
			body.angle *= pad_data[pad].angle_mult
