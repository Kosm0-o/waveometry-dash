extends LevelObject

enum ORBS {YELLOW, PINK, RED, DROP, SPIDER, BLUE, DASH, PINKDASH}
@export var orb : ORBS = ORBS.DROP

# negative boost = down, positive = up

var orb_data : Array = [
	{
		"name": "yellow",
		"boost": 7500
	},
	{
		"name": "pink",
		"boost": 2500
	},
	{
		"name": "red",
		"boost": 15000
	},
	{
		"name": "drop",
		"boost": -5000
	},
	{
		"name": "spider",
		"boost": -50000
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


 

func _ready() -> void:
	match get_meta("id"):
		"yelloworb":
			orb = ORBS.YELLOW
		"pinkorb":
			orb = ORBS.PINK
		"redorb":
			orb = ORBS.RED
		"spiderorb":
			orb = ORBS.SPIDER
		"blueorb":
			orb = ORBS.BLUE
		"droporb":
			orb = ORBS.DROP
		"dashorb":
			orb = ORBS.DASH
		"pinkdashorb":
			orb = ORBS.PINKDASH
	$AnimatedSprite2D.play(orb_data[orb].name)
	if orb == ORBS.SPIDER and flipped: rotation += PI

func _process(delta: float) -> void:
	var getp = $Area2D.get_overlapping_bodies()
	if getp.size() > 0 and Input.is_action_just_pressed("click"):
		var player = getp.front()
		match orb:
			ORBS.DROP:
				player.dropping = true
				player.y_boost = orb_data[orb].boost * sign(player.angle)
				
			
			ORBS.SPIDER:
				player.dropping = true
				var m : int = -1 if flipped else 1
				player.y_boost = orb_data[orb].boost * m
				
			
			ORBS.YELLOW, ORBS.PINK, ORBS.RED:
				player.y_boost = orb_data[orb].boost * sign(player.angle)
			
			ORBS.BLUE:
				player.angle *= orb_data[orb].angle_mult
			
			ORBS.DASH, ORBS.PINKDASH:
				player.dashing["true"] = true
				player.dashing.pink = true if orb == ORBS.PINKDASH else false
		
		size_tween()


func size_tween():
	var tween = create_tween().set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_CUBIC)
	var og_scale = scale
	tween.tween_property(self, "scale", Vector2.ONE, 0.2)
	tween.tween_property(self, "scale", og_scale, 0.2)
	await tween.finished
	
