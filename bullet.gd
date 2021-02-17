class_name Bullet
extends Area2D

var velocity = Vector2(100, 0)

func _ready() -> void:
	pass

func _physics_process(delta: float) -> void:
	position += velocity * delta


func _on_VisibilityNotifier2D_viewport_exited(_viewport: Viewport) -> void:
	queue_free()
