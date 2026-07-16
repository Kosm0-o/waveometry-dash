extends LevelObject

enum PADS {YELLOW, PINK, RED, SPIDER, BLUE}
var pad : PADS = PADS.YELLOW

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


func object_ready() -> void:
	match get_meta("id"):
		"yellowpad":
			pad = PADS.YELLOW
		"pinkpad":
			pad = PADS.PINK
		"redpad":
			pad = PADS.RED
		"spiderpad":
			pad = PADS.SPIDER
		"bluepad":
			pad = PADS.BLUE
	$AnimatedSprite2D.play(pad_data[pad].name)
	if pad == PADS.SPIDER and flipped: rotation += PI
	


func _on_area_2d_body_entered(body: Node2D) -> void:
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
