extends Particles2D

var vel: Vector2 = Vector2()

func _ready() -> void:
	emitting = true
	one_shot = true

func _process(delta: float) -> void:
	position += vel * delta
	if not emitting:
		queue_free()
