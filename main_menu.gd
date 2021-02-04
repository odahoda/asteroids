extends Control

signal quit_pressed
signal settings_pressed
signal play_pressed

func _ready() -> void:
	$buttons/quit.connect('button_up', self, '__quit_pressed')
	$buttons/play.connect('button_up', self, '__play_pressed')
	$buttons/settings.connect('button_up', self, '__settings_pressed')

func __quit_pressed() -> void:
	emit_signal('quit_pressed')

func __play_pressed() -> void:
	emit_signal('play_pressed')
	
func __settings_pressed() -> void:
	emit_signal('settings_pressed')
