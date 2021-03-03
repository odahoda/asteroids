class_name Aster
extends Area2D

signal collided

var vel: Vector2 = Vector2()
var shape: String = 'big'
var spawn_group: int = 0
var dead = false
var lifetime = 0.0

func _ready() -> void:
	$sprite.animation = shape
	if shape == 'big':
		$collision_big.disabled = false
	elif shape == 'medium':
		$collision_medium.disabled = false
	else:
		$collision_small.disabled = false

	$sprite.speed_scale = rand_range(0.5, 1.5)
	$animation.playback_speed = rand_range(-5, 5)
	$animation.play("rotation")

func _process(delta: float) -> void:
	lifetime += delta
	if lifetime > 0.3:
		spawn_group = 0

	position += vel * delta

	var screen = get_viewport_rect().size
	if position.x < -32:
		position.x = screen.x + 32
	elif position.x >= screen.x + 32:
		position.x = -32
	if position.y < -32:
		position.y = screen.y + 32
	elif position.y >= screen.y + 32:
		position.y = -32

func _on_Area2D_area_entered(area: Area2D) -> void:
	if not dead:
		emit_signal('collided', self, area)

func die():
	dead = true
	$collision_big.set_deferred('disabled', true)
	$collision_medium.set_deferred('disabled', true)
	$collision_small.set_deferred('disabled', true)
	queue_free()
