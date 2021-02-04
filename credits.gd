extends Container

onready var text = $'text';

func _ready() -> void:
	var f = File.new()
	f.open("res://credits.txt", File.READ)
	text.bbcode_text = f.get_as_text()
	f.close()
	var h = text.rect_size.y
	text.margin_bottom = rect_size.y + h
	text.margin_top = rect_size.y

func _process(delta: float) -> void:
	var h = text.rect_size.y
	text.margin_top -= 50 * delta
	if -text.margin_top > text.rect_size.y:
		text.margin_top = rect_size.y
	text.margin_bottom = text.margin_top + h
