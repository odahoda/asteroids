extends Node2D

var level_scene = preload("res://level.tscn")
var level = null
var main_menu_scene = preload("res://main_menu.tscn")
var main_menu = null

func _ready() -> void:
	randomize()
	set_state('menu')

func set_state(state: String) -> void:
	if state == 'menu':
		main_menu = main_menu_scene.instance()
		main_menu.connect('quit_pressed', self, 'quit_game')
		main_menu.connect('play_pressed', self, 'start_level')
		add_child(main_menu)

	elif state == 'play':
		main_menu.queue_free()
		main_menu = null

		level = level_scene.instance()
		level.connect('finished', self, 'level_finished')
		add_child(level)

	elif state == 'quit':
		main_menu.queue_free()
		main_menu = null
		get_tree().quit()

	else:
		print("huh?")

func quit_game() -> void:
	main_menu.fade_out(self, 'set_state', ['quit'])
	
func start_level() -> void:
	main_menu.fade_out(self, 'set_state', ['play'])

func level_finished() -> void:
	level.queue_free()
	level = null
	set_state('menu')
