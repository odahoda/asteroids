class_name Bullet
extends Area2D

var velocity = Vector2(100, 0)
var lifetime = 0.0

func _ready() -> void:
	pass

func _process(delta: float) -> void:
	lifetime += delta
	if lifetime > 2.0 and not $animations.is_playing():
		$animations.play('fade')
		$animations.connect('animation_finished', self, '__faded', [], CONNECT_ONESHOT)

	position += velocity * delta

	var screen = get_viewport_rect().size
	if position.x < -32:
		position.x = screen.x + 32
	elif position.x >= screen.x + 32:
		position.x = -32
	if position.y < -32:
		position.y = screen.y + 32
	elif position.y >= screen.y + 32:
		position.y = -32

func __faded(_anim) -> void:
	queue_free()
