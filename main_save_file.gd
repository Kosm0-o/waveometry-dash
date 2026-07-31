extends Node

const main_file_name : String = "user://WaveometryDashMainSaveFile.json"

func save_user_data():
	var file = FileAccess.open(main_file_name, FileAccess.WRITE)
	file.store_string(
		JSON.stringify(
			{
			"progress": global.progress,
			"music_volume": AudioServer.get_bus_volume_db(AudioServer.get_bus_index("Music")),
			"sfx_volume": AudioServer.get_bus_volume_db(AudioServer.get_bus_index("SFX")),
			"game_mode_indicator": global.gamemodeindicator,
			"low_detail_mode": global.lowdetailmode
			}
		)
	)
	file.close()

func load_user_data():
	var file = FileAccess.open(main_file_name, FileAccess.READ)
	if file == null:
		save_user_data()
		file = FileAccess.open(main_file_name, FileAccess.READ)
	var data = JSON.parse_string(file.get_as_text())
	file.close()
	return data
	
