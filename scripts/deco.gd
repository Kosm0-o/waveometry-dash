extends LevelObject

@onready var sprite: TextureRect = $sprite


enum DECO {SQUARE, CIRCLE, SEMICIRCLE, QUARTERCIRCLE, GLOW, TRIANGLE, LINE}
@export var deco : DECO = DECO.SQUARE

var atlas_regions : Array[Dictionary] = [
	{
		"name": "square",
		"region": Rect2(4415.0, 1203.0, 143.0, 143.0)
	},
	{
		"name": "circle",
		"region": Rect2(5689.0, 1195.0, 160.0, 160.0)
	},
	{
		"name": "semicircle",
		"region": Rect2(560.0, 1744.0, 161.0, 81.0)
	},
	{
		"name": "quartercircle",
		"region": Rect2(1882.0, 1744.0, 81.0, 81.0)
	},
	{
		"name": "glow",
		"region": Rect2(3133.0, 1203.0, 144.0, 144.0)
	},
	{
		"name": "triangle",
		"region": Rect2(3168.0, 1734.0, 73.0, 101.0)
	},
	{
		"name": "line",
		"region": Rect2(4440.0, 1782.0, 94.0, 6.0)
	}
]

func object_ready():
	#forgot to use spritesheet bruh lol
	match get_meta("id"):
		"squaredeco":
			deco = DECO.SQUARE
		"circledeco":
			deco = DECO.CIRCLE
		"semicircledeco":
			deco = DECO.SEMICIRCLE
		"quartercircledeco":
			deco = DECO.QUARTERCIRCLE
		"glowdeco":
			deco = DECO.GLOW
		"triangledeco":
			deco = DECO.TRIANGLE
		"linedeco":
			deco = DECO.LINE
	sprite.texture = sprite.texture.duplicate()
	var reg = atlas_regions[deco].region
	sprite.texture.region = reg
	sprite.size = reg.size
	var subscale = min(89.0 / sprite.size.x, 89.0 / sprite.size.y)
	sprite.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	sprite.size *= subscale
	if deco == DECO.GLOW:
		sprite.material.blend_mode = CanvasItemMaterial.BLEND_MODE_ADD
	sprite.position = Vector2(
		-sprite.size.x / 2,
		-sprite.size.y / 2
	)
