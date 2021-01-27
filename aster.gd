class_name Aster
extends Area2D

signal collided

var vel: Vector2 = Vector2()
var shape: String = 'big'
var spawn_group: int = 0
var dead = false

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

	#vel = Vector2(rand_range(100, 500), 0).rotated(rand_range(0, 2 * PI))

func _physics_process(delta: float) -> void:
	position += vel * delta

func _on_visibility_viewport_exited(_viewport: Viewport) -> void:
	#print("bye")
	queue_free()

func _on_Area2D_area_entered(area: Area2D) -> void:
	if not dead:
		emit_signal('collided', self, area)

func die():
	dead = true
	$collision_big.set_deferred('disabled', true)
	$collision_medium.set_deferred('disabled', true)
	$collision_small.set_deferred('disabled', true)
	queue_free()
