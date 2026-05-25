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
		"boost": -6000
	},
	{
		"name": "blue",
		"angle_mult": -1 
	}
]

@export_category("SPIDER PAD ONLY")
@export var flipped : bool = false

func _ready() -> void:
	pass
	
func _on_body_entered(body: Node2D) -> void:
	match pad:
		PADS.SPIDER:
			var m = -1 if flipped else 1
			body.down(pad_data[pad].boost * m)
		
		PADS.YELLOW, PADS.PINK, PADS.RED:
			body.y_boost = pad_data[pad].boost
			
		PADS.BLUE:
			body.angle *= pad_data[pad].angle_mult
