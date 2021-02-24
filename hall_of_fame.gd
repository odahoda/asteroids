extends Control

signal closed

var closing = false
var scores = [
	["fred", 10000],
	["clara", 1400],
	["paul", 1200],
	["fred", 1000],
	["clara", 800],
	["paul", 750],
	["fred", 600],
	["claudia", 500],
	["fred", 400],
	["fred", 320],
]

func _ready() -> void:
	refresh_scores()
	$animations.play('fade_in')
	$animations.seek(0, true)

func _input(event):
	if event is InputEventKey and not closing:
		closing = true
		$animations.play('fade_out')
		$animations.connect('animation_finished', self, '__fade_out_finished', [], CONNECT_ONESHOT)

func refresh_scores() -> void:
	var box = $box/scores

	var idx = 1
	for entry in scores:
		var rank = Label.new()
		rank.text = str(idx)
		rank.align = Label.ALIGN_RIGHT
		rank.size_flags_vertical = Control.SIZE_EXPAND
		box.add_child(rank)

		var name = Label.new()
		name.text = entry[0]
		name.size_flags_horizontal = Control.SIZE_EXPAND
		name.size_flags_vertical = Control.SIZE_EXPAND
		box.add_child(name)

		var score = Label.new()
		score.text = str(entry[1])
		score.align = Label.ALIGN_RIGHT
		score.size_flags_vertical = Control.SIZE_EXPAND
		box.add_child(score)

		idx += 1

func __fade_out_finished(anim) -> void:
	emit_signal('closed')
