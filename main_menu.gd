extends CanvasLayer

signal quit_pressed
signal settings_pressed
signal highscores_pressed
signal play_pressed
onready var quit_button = $controls/buttons/quit
onready var play_button = $controls/buttons/play
onready var highscores_button = $controls/buttons/highscores
onready var settings_button = $controls/buttons/settings

func _ready() -> void:
	quit_button.connect('button_up', self, 'emit_signal', ['quit_pressed'])
	play_button.connect('button_up', self, 'emit_signal', ['play_pressed'])
	highscores_button.connect('button_up', self, 'emit_signal', ['highscores_pressed'])
	settings_button.connect('button_up', self, 'emit_signal', ['settings_pressed'])
	$animations.play('fade_in')
	$animations.seek(0, true)
	
	var music_player = get_node('/root/game/music_player')
	if music_player != null:
		music_player.play_song("res://assets/ac-ll.ogg")

	play_button.grab_focus()

func _input(event):
	if event.is_action_pressed("ui_cancel"):
		quit_button.grab_focus()
		emit_signal('quit_pressed')

func fade_out(cb_obj, cb_func, cb_args=[]) -> void:
	$animations.play('fade_out')
	$animations.connect('animation_finished', self, '__fade_out_finished', [cb_obj, cb_func, cb_args], CONNECT_ONESHOT)

func __fade_out_finished(_anim, cb_obj, cb_func, cb_args) -> void:
	cb_obj.callv(cb_func, cb_args)
