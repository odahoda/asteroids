extends Node

var settings = null

func _ready() -> void:
	load_settings()

func load_settings() -> void:
	var fp = File.new()
	if fp.file_exists("user://settings.json"):
		fp.open("user://settings.json", File.READ)
		settings = parse_json(fp.get_as_text())
		fp.close()

	else:
		settings = {
			'fullscreen': false,
			'music_volume': 100,
			'sound_volume': 100,
		}

	__apply_fullscreen()
	__apply_music_volume()
	__apply_sound_volume()

func save_settings() -> void:
	var fp = File.new()
	fp.open("user://settings.json", File.WRITE)
	fp.store_string(to_json(settings))
	fp.close()

func get_fullscreen() -> bool:
	return settings['fullscreen']

func set_fullscreen(value) -> void:
	settings['fullscreen'] = value
	__apply_fullscreen()

func __apply_fullscreen() -> void:
	OS.window_fullscreen = settings['fullscreen']

func get_music_volume() -> int:
	return settings['music_volume']

func set_music_volume(value) -> void:
	settings['music_volume'] = value
	__apply_music_volume()
	
func __apply_music_volume() -> void:
	var bus_idx = AudioServer.get_bus_index('music')
	var value = settings['music_volume']
	if value == 0:
		AudioServer.set_bus_mute(bus_idx, true)
	else:
		var value_db = 10 * log(value / 100)
		AudioServer.set_bus_mute(bus_idx, false)
		AudioServer.set_bus_volume_db(bus_idx, value_db)

func get_sound_volume() -> int:
	return settings['sound_volume']

func set_sound_volume(value) -> void:
	settings['sound_volume'] = value
	__apply_sound_volume()

func __apply_sound_volume() -> void:
	var bus_idx = AudioServer.get_bus_index('sfx')
	var value = settings['sound_volume']
	if value == 0:
		AudioServer.set_bus_mute(bus_idx, true)
	else:
		var value_db = 10 * log(value / 100)
		AudioServer.set_bus_mute(bus_idx, false)
		AudioServer.set_bus_volume_db(bus_idx, value_db)
