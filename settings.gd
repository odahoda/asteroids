extends Control

signal done

var settings = null

onready var done_button = $controls/done
onready var fullscreen_button = $controls/grid/fullscreen
onready var music_volume_slider = $controls/grid/music_volume
onready var sound_volume_slider = $controls/grid/sound_volume

func _ready() -> void:
	done_button.connect('button_up', self, 'fade_out')
	fullscreen_button.connect('toggled', self, '__fullscreen_changed')
	music_volume_slider.connect('value_changed', self, '__music_volume_changed')
	sound_volume_slider.connect('value_changed', self, '__sound_volume_changed')

func _input(event):
	if event.is_action_pressed("ui_cancel") and visible:
		done_button.grab_focus()
		fade_out()

func fade_in() -> void:
	$animations.play('fade_in')
	$animations.seek(0, true)

func fade_out() -> void:
	$animations.play('fade_out')
	$animations.connect('animation_finished', self, '__fade_out_finished', [], CONNECT_ONESHOT)

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

	fullscreen_button.pressed = settings['fullscreen']
	__apply_fullscreen()

	music_volume_slider.value = settings['music_volume']
	__apply_music_volume()

	sound_volume_slider.value = settings['sound_volume']
	__apply_sound_volume()

func save_settings() -> void:
	var fp = File.new()
	fp.open("user://settings.json", File.WRITE)
	fp.store_string(to_json(settings))
	fp.close()

func __fade_out_finished(_anim) -> void:
	save_settings()
	emit_signal('done')

func __fullscreen_changed(value) -> void:
	settings['fullscreen'] = value
	__apply_fullscreen()
	
func __apply_fullscreen() -> void:
	OS.window_fullscreen = settings['fullscreen']

func __music_volume_changed(value) -> void:
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

func __sound_volume_changed(value) -> void:
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
