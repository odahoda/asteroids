extends CanvasLayer

var level_scene = preload("res://level.tscn")
var level = null
var main_menu_scene = preload("res://main_menu.tscn")
var main_menu = null
var hall_of_fame_scene = preload("res://hall_of_fame.tscn")
var hall_of_fame = null
var settings_scene = preload("res://settings_ui.tscn")
var settings = null

func _ready() -> void:
	randomize()

	set_state('menu')

func set_state(state: String) -> void:
	if state == 'menu':
		assert(main_menu == null)
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		main_menu = main_menu_scene.instance()
		main_menu.connect('quit_pressed', self, 'quit_game')
		main_menu.connect('settings_pressed', self, 'show_settings')
		main_menu.connect('play_pressed', self, 'start_level')
		main_menu.connect('highscores_pressed', self, 'show_highscores')
		add_child(main_menu)

	elif state == 'highscores':
		assert(main_menu != null)
		main_menu.queue_free()
		main_menu = null

		assert(hall_of_fame == null)
		hall_of_fame = hall_of_fame_scene.instance()
		hall_of_fame.connect('closed', self, 'highscores_finished')
		add_child(hall_of_fame)

	elif state == 'settings':
		assert(main_menu != null)
		main_menu.queue_free()
		main_menu = null

		assert(settings == null)
		settings = settings_scene.instance()
		settings.connect('done', self, 'settings_finished')
		add_child(settings)
	
	elif state == 'play':
		assert(main_menu != null)
		main_menu.queue_free()
		main_menu = null

		assert(level == null)
		level = level_scene.instance()
		level.connect('finished', self, 'level_finished')
		add_child(level)

	elif state == 'quit':
		assert(main_menu != null)
		main_menu.queue_free()
		main_menu = null
		get_tree().quit()

	else:
		print("huh?")

func quit_game() -> void:
	print("quit_game")
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
	$music_player.fade_out()
	main_menu.fade_out(self, 'set_state', ['quit'])
	
func show_highscores() -> void:
	print("show_highscores")
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
	main_menu.fade_out(self, 'set_state', ['highscores'])

func highscores_finished() -> void:
	print("highscore_finished")
	assert(hall_of_fame != null)
	hall_of_fame.queue_free()
	hall_of_fame = null
	set_state('menu')

func show_settings() -> void:
	print("show_settings")
	main_menu.fade_out(self, 'set_state', ['settings'])

func settings_finished() -> void:
	print("settings_finished")
	$settings.visible = false
	set_state('menu')

func start_level() -> void:
	print("start_level")
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
	main_menu.fade_out(self, 'set_state', ['play'])

func level_finished() -> void:
	print("level_finished")
	var score = level.score
	level.queue_free()
	level = null
	if score > 0:
		assert(hall_of_fame == null)
		hall_of_fame = hall_of_fame_scene.instance()
		hall_of_fame.set_score(score)
		hall_of_fame.connect('closed', self, 'highscores_finished')
		add_child(hall_of_fame)
		
		$music_player.play_song("res://assets/ac-mp.ogg")

	else:
		set_state('menu')
