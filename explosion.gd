extends Particles2D


func _ready() -> void:
	emitting = true
	one_shot = true

func _process(_delta: float) -> void:
	if not emitting:
		queue_free()
