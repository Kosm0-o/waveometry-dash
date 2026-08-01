extends LevelObject

@onready var shape : RectangleShape2D = $clickdetector/CollisionShape2D.shape

func object_ready():
	$Label.label_settings = $Label.label_settings.duplicate()

func _process(delta: float) -> void:
	$Label.text = objecttext
	$Label.label_settings.font_size = font_size
	shape.size = $Label.size
	$clickdetector/CollisionShape2D.position = shape.size / 2 + $Label.position
