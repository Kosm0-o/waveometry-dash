extends Node

signal portal_entered(portal)
signal died()
signal level_complete()


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
	"time_leaper": 0.0
}

var startpos : Vector2 = Vector2.ZERO
var endpos : LevelObject = null
var attempts : int = 0
var time_passed : float = 0.0
var main_level : bool = false
var main_level_id : String = ""
var gamemodeindicator : bool = true
var auto_save_timer : float = 0.0

func _ready() -> void:
	global.process_mode = Node.PROCESS_MODE_ALWAYS
	var user_data = MainSaveFile.load_user_data()
	progress = user_data.progress
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Music"), user_data.music_volume)
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("SFX"), user_data.sfx_volume)
	gamemodeindicator = user_data.game_mode_indicator
	lowdetailmode = user_data.low_detail_mode
	

func _process(delta: float) -> void:
	xangle = layout_rotation == 0 or layout_rotation == 180
	yangle = layout_rotation == 90 or layout_rotation == 270
	if pnode != null: players = pnode.get_children()
	auto_save_timer += delta
	if auto_save_timer >= 10.0:
		MainSaveFile.save_user_data()
		auto_save_timer = 0.0

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
