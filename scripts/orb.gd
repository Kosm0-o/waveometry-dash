extends Area2D

enum ORBS {YELLOW, PINK, RED, DROP, SPIDER, BLUE, DASH, PINKDASH}
@export var orb : ORBS = ORBS.DROP

# negative boost = down, positive = up

var orb_data : Array = [
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
		"name": "drop",
		"boost": -2500
	},
	{
		"name": "spider",
		"boost": -6000
	},
	{
		"name": "blue",
		"angle_mult": -1 
	},
	{
		"name": "dash"
	},
	{
		"name": "pinkdash"
	}
]
@export_category("SPIDER ORB ONLY")
@export var flipped : bool = false


var p 

func _ready() -> void:
	pass

func _process(delta: float) -> void:
	var getp = get_overlapping_bodies()
	if getp.size() > 0 and Input.is_action_just_pressed("click"):
		match orb:
			ORBS.DROP, ORBS.SPIDER:
				var m = -1 if flipped and orb == ORBS.SPIDER else 1
				getp.front().down(orb_data[orb].boost * m)
			
			ORBS.YELLOW, ORBS.PINK, ORBS.RED:
				getp.front().y_boost = orb_data[orb].boost
			
			ORBS.BLUE:
				getp.front().angle *= orb_data[orb].angle_mult
			
			ORBS.DASH, ORBS.PINKDASH:
				p = getp.front()
	if p != null:
		var m : int = 1 if orb == ORBS.DASH else -1
		if Input.is_action_pressed("click"):
			p.dashing = true
		else:
			p.angle *= m
			p.dashing = false
			p = null
	
