class_name Player
extends Area2D

const ROT_SPEED = 200
const ACCEL = 500
const MAX_VELOCITY = 400

var velocity = Vector2(0, 0)
var shield_counter = 2
var shield_hit = 0

func _ready() -> void:
	$thruster.visible = false
	$thruster_smoke.emitting = false
	enable_shield()
	var _unused = connect("area_entered", self, "_on_collision")

func _process(delta: float) -> void:
	if shield_counter >= 0:
		update_shield(delta)

	if Input.is_action_pressed("ui_right"):
		rotation_degrees += ROT_SPEED * delta
	if Input.is_action_pressed("ui_left"):
		rotation_degrees -= ROT_SPEED * delta
	if Input.is_action_pressed("ui_up"):
		velocity += Vector2(0, -ACCEL * delta).rotated(rotation)
		velocity = min(velocity.length(), MAX_VELOCITY) * velocity.normalized()
		$thruster.visible = true
		$thruster_smoke.emitting = true
	else:
		$thruster.visible = false
		$thruster_smoke.emitting = false

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

func _on_collision(other: Area2D):
	if shield_counter > 0 and other is Aster:
		shield_hit = 0.4

func enable_shield():
	$shield.visible = true
	$shield.self_modulate = Color(1, 1, 1, 1)
	$shape_shield.disabled = false
	$shape_player.disabled = true
	shield_counter = 5

func disable_shield():
	$shield.visible = false
	$shape_shield.disabled = true
	$shape_player.disabled = false
	shield_counter = 0

func update_shield(delta):
	shield_counter = max(shield_counter - delta, 0)
	if shield_counter == 0:
		disable_shield()
		return

	if shield_hit > 0:
		shield_hit = max(shield_hit - delta, 0)
		var v = shield_hit / 0.4
		$shield.self_modulate = Color(1, 1 - v, 1 - v, 1)

	if shield_counter < 0.5:
		var f = int(shield_counter / 0.03)
		$shield.visible = (f % 2 == 0)
	elif shield_counter < 1.0:
		var f = int(shield_counter / 0.05)
		$shield.visible = (f % 2 == 0)
	elif shield_counter < 2.0:
		var f = int(shield_counter / 0.05)
		$shield.visible = (f % 4 < 3)
