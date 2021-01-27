class_name Player
extends Area2D

const ROT_SPEED = 200
const ACCEL = 500

var velocity = Vector2(0, 0)

func _ready() -> void:
	pass

func _process(delta: float) -> void:
	if Input.is_action_pressed("ui_right"):
		rotation_degrees += ROT_SPEED * delta
	if Input.is_action_pressed("ui_left"):
		rotation_degrees -= ROT_SPEED * delta
	if Input.is_action_pressed("ui_up"):
		velocity += Vector2(0, -ACCEL * delta).rotated(rotation)
		
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
