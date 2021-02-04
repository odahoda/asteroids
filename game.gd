extends Node2D

var game_state = 'menu'
var next_state = null
onready var main_menu = $HUD/main_menu
onready var level = $level
onready var animations = $animations

func _ready() -> void:
	randomize()
	main_menu.connect('quit_pressed', self, 'quit_game')
	main_menu.connect('play_pressed', self, 'start_level')
	level.connect('finished', self, 'level_finished')
	animations.connect('animation_finished', self, 'animation_finished')

	set_state('menu')

func set_state(state: String) -> void:
	game_state = state
	if state == 'menu':
		main_menu.visible = true
		level.visible = false
	elif state == 'play':
		main_menu.visible = false
		level.visible = true
	elif state == 'quit':
		main_menu.visible = false
		level.visible = false
		get_tree().quit()
	else:
		print("huh?")

func animation_finished(anim) -> void:
	animations.seek(0, true)
	set_state(next_state)
		
func quit_game() -> void:
	next_state = 'quit'
	animations.play('menu_out')
	
func start_level() -> void:
	next_state = 'play'
	animations.play('menu_out')

func level_finished() -> void:
	set_state('menu')
