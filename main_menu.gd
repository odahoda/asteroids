extends CanvasLayer

signal quit_pressed
signal settings_pressed
signal play_pressed
onready var quit_button = $controls/buttons/quit
onready var play_button = $controls/buttons/play
onready var settings_button = $controls/buttons/settings

func _ready() -> void:
	quit_button.connect('button_up', self, '__quit_pressed')
	play_button.connect('button_up', self, '__play_pressed')
	settings_button.connect('button_up', self, '__settings_pressed')
	$animations.play('fade_in')
	$animations.seek(0, true)
	$music.play()
	play_button.grab_focus()

func _input(event):
	if event.is_action_pressed("ui_cancel"):
		quit_button.grab_focus()
		emit_signal('quit_pressed')

func __quit_pressed() -> void:
	emit_signal('quit_pressed')

func __play_pressed() -> void:
	emit_signal('play_pressed')
	
func __settings_pressed() -> void:
	emit_signal('settings_pressed')

func fade_out(cb_obj, cb_func, cb_args=[]) -> void:
	$animations.play('fade_out')
	$animations.connect('animation_finished', self, '__fade_out_finished', [cb_obj, cb_func, cb_args], CONNECT_ONESHOT)

func __fade_out_finished(_anim, cb_obj, cb_func, cb_args) -> void:
	cb_obj.callv(cb_func, cb_args)
