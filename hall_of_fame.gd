extends Control

signal closed

var new_pos = null
var opening = true
var closing = false
var editing = false
var editor = null
var scores = []

func _init() -> void:
	load_scores()

func _ready() -> void:
	refresh_scores()
	$animations.play('fade_in')
	$animations.seek(0, true)
	var _unused = $animations.connect('animation_finished', self, '__fade_in_finished', [], CONNECT_ONESHOT)

func _unhandled_key_input(_event: InputEventKey) -> void:
	if not opening and not closing and not editing:
		closing = true
		$animations.play('fade_out')
		var _unused = $animations.connect('animation_finished', self, '__fade_out_finished', [], CONNECT_ONESHOT)

func set_score(score: int) -> void:
	if score != null:
		var pos = 0
		for entry in scores:
			if score > entry[1]:
				new_pos = pos
				break
			pos += 1

	if new_pos != null:
		scores.insert(new_pos, ["", score])
		while len(scores) > 10:
			scores.pop_back()

	refresh_scores()

func load_scores() -> void:
	var fp = File.new()
	if fp.file_exists("user://highscores.json"):
		fp.open("user://highscores.json", File.READ)
		scores = parse_json(fp.get_as_text())
		fp.close()

	else:
		scores = [
			["albert", 10000],
			["stephen", 5000],
			["pink", 2500],
			["", 0],
			["", 0],
			["", 0],
			["", 0],
			["", 0],
			["", 0],
			["", 0],
		]

func save_scores() -> void:
	var fp = File.new()
	fp.open("user://highscores.json", File.WRITE)
	fp.store_string(to_json(scores))
	fp.close()

func refresh_scores() -> void:
	var box = $box/scores
	
	editor = null
	while box.get_child_count() > 0:
		var child = box.get_child(0)
		box.remove_child(child)
		child.queue_free()

	var idx = 1
	for entry in scores:
		var rank = Label.new()
		rank.text = str(idx)
		rank.align = Label.ALIGN_RIGHT
		rank.size_flags_vertical = Control.SIZE_EXPAND
		box.add_child(rank)

		if idx - 1 == new_pos:
			editor = LineEdit.new()
			editor.placeholder_text = "Your Name..."
			editor.caret_blink = true
			editor.max_length = 12
			editor.size_flags_horizontal = Control.SIZE_EXPAND_FILL
			editor.size_flags_vertical = Control.SIZE_EXPAND
			box.add_child(editor)
		else:
			var name = Label.new()
			name.text = entry[0]
			name.size_flags_horizontal = Control.SIZE_EXPAND
			name.size_flags_vertical = Control.SIZE_EXPAND
			box.add_child(name)

		var score = Label.new()
		score.text = str(entry[1]) if entry[1] > 0 else ""
		score.align = Label.ALIGN_RIGHT
		score.size_flags_vertical = Control.SIZE_EXPAND
		box.add_child(score)

		idx += 1

	if editor != null:
		editing = true
		editor.connect('text_entered', self, "__editing_finished", [])

func __fade_in_finished(_anim) -> void:
	if editor != null:
		editor.grab_focus()

	opening = false
	if new_pos != null:
		$message.text = "New Highscore!"
	else:
		$message.text = "Press Any Key to Continue"
			
	$animations.play('msg_fade')

func __fade_out_finished(_anim) -> void:
	emit_signal('closed')

func __editing_finished(name) -> void:
	if len(name) > 0:
		scores[new_pos][0] = name
		save_scores()
		new_pos = null
		refresh_scores()
		$animations.play_backwards('msg_fade')
		yield ($animations, 'animation_finished')
		editing = false
		$message.text = "Press Any Key to Continue"
		$animations.play('msg_fade')
