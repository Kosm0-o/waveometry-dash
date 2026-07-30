extends Node

signal portal_entered(portal)
signal died()


var mirror_tweening : bool = false
var rotation_tweening : bool = false
var dualing : bool = false
var exit_teleportals : Array[Teleportal] = []
var players : Array = []
var pnode : Node2D = null
var bounds : float = 630
var cam_offset : float
var lowdetailmode : bool = false
var complete_details : bool = false
var layout_rotation : float = 0.0 # in degrees
var xangle : bool = layout_rotation == 0 or layout_rotation == 180 # when you travel horizontally
var yangle : bool = layout_rotation == 90 or layout_rotation == 270 # when you travel vertically
var practice_mode : bool = false
var all_checkpoints : Array = []
var bg : Control = null
var trans_rect : ColorRect = null
var progress : Dictionary = {
	"time_leaper": 25.3
}

var startpos : Vector2 = Vector2.ZERO

func _process(delta: float) -> void:
	xangle = layout_rotation == 0 or layout_rotation == 180
	yangle = layout_rotation == 90 or layout_rotation == 270
	if pnode != null: players = pnode.get_children()

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ldm"):
		lowdetailmode = not lowdetailmode
		complete_details = false

func fade_tween(fade_in : bool, time : float = 1.0):
	RenderingServer.set_default_clear_color(Color.BLACK)
	var tween = create_tween().set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT if not fade_in else Tween.EASE_IN)
	tween.tween_property(trans_rect, "modulate:a", 1.0 if fade_in else 0.0, time)
	await tween.finished
	RenderingServer.set_default_clear_color(Color.BLACK)
