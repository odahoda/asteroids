extends Label

func _ready() -> void:
	modulate.a = 0

func _input(event):
	if event.is_action_pressed("ui_pause"):
		if get_tree().is_paused():
			get_tree().set_pause(false)
			$fade.play('fade_out')
		else:
			get_tree().set_pause(true)
			$fade.play('fade_in')
