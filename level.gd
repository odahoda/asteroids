extends Node2D

signal finished

var aster_scene = preload("res://aster.tscn")
var explosion_scene = preload("res://explosion.tscn")
var bullet_scene = preload("res://bullet.tscn")
var player_scene = preload("res://player.tscn")
var spawn
var next_spawn_group = 0
var score: int = 0

func _ready() -> void:
	randomize()
	spawn = 0.0
	score = 0
	$HUD/score.text = "%s" % score
	
	var player = player_scene.instance()
	add_child(player)
	$player.position = get_viewport_rect().size / 2

func _physics_process(delta: float) -> void:
	spawn -= delta
	if spawn <= 0:
		spawn = 0.5
		spawn_aster()

func _input(event):
	if event.is_action_pressed("ui_accept"):
		shoot()
	if event.is_action_pressed("ui_cancel"):
		emit_signal('finished')

func collect_score(amount):
	score += amount
	$HUD/score.text = "%s" % score

func spawn_aster() -> void:
	$spawn_path/location.offset = randi()
	
	var pos = $spawn_path/location.position
	var screen = get_viewport_rect().size
	var target = Vector2(screen.x * rand_range(0.3, 0.7), screen.y * rand_range(0.3, 0.7))
	var dir = pos.angle_to_point(target) + PI
	create_aster(
		['big', 'medium', 'small'][randi() % 3],
		pos,
		Vector2(rand_range(50, 100), 0).rotated(dir),
		next_spawn_group)
	next_spawn_group += 1

func create_aster(shape: String, pos: Vector2, vel: Vector2, spawn_group: int = 0) -> void:
	var aster = aster_scene.instance()
	aster.shape = shape
	aster.position = pos
	aster.vel = vel
	aster.spawn_group = spawn_group
	aster.connect('collided', self, 'handle_collision')
	call_deferred("add_child", aster)

func handle_collision(o1: Area2D, o2: Area2D):
	if o1 is Aster and o2 is Aster and o1.spawn_group != o2.spawn_group:
		explode(o1, o2)
		o1.die()
		o2.die()
		
	if o2 is Player or o2 is Bullet:
		var t = o1
		o1 = o2
		o2 = t

	if o1 is Player:
		var explosion = explosion_scene.instance()
		explosion.position = o2.position
		call_deferred("add_child", explosion)
		o2.die()

	if o1 is Bullet and o2 is Aster:
		if o2.shape == 'big':
			create_aster('medium', o2.position, Vector2(rand_range(100, 400), 0).rotated(rand_range(0, 2*PI)), next_spawn_group)
			create_aster('medium', o2.position, Vector2(rand_range(100, 400), 0).rotated(rand_range(0, 2*PI)), next_spawn_group)
			collect_score(50)
		elif o2.shape == 'medium':
			create_aster('small', o2.position, Vector2(rand_range(100, 400), 0).rotated(rand_range(0, 2*PI)), next_spawn_group)
			create_aster('small', o2.position, Vector2(rand_range(100, 400), 0).rotated(rand_range(0, 2*PI)), next_spawn_group)
			collect_score(20)
		else:
			collect_score(10)
		next_spawn_group += 1

		var explosion = explosion_scene.instance()
		explosion.position = o2.position
		call_deferred("add_child", explosion)
		o2.die()
		o1.queue_free()

func explode(a1: Aster, a2: Aster) -> void:
	for a in [a1, a2]:
		if a.shape == 'big':
			create_aster('medium', a.position, Vector2(rand_range(100, 400), 0).rotated(rand_range(0, 2*PI)), next_spawn_group)
			create_aster('medium', a.position, Vector2(rand_range(100, 400), 0).rotated(rand_range(0, 2*PI)), next_spawn_group)
			create_aster('small', a.position, Vector2(rand_range(200, 300), 0).rotated(rand_range(0, 2*PI)), next_spawn_group)
			create_aster('small', a.position, Vector2(rand_range(200, 300), 0).rotated(rand_range(0, 2*PI)), next_spawn_group)
		elif a.shape == 'medium':
			create_aster('small', a.position, Vector2(rand_range(100, 400), 0).rotated(rand_range(0, 2*PI)), next_spawn_group)
			create_aster('small', a.position, Vector2(rand_range(100, 400), 0).rotated(rand_range(0, 2*PI)), next_spawn_group)
			create_aster('small', a.position, Vector2(rand_range(100, 400), 0).rotated(rand_range(0, 2*PI)), next_spawn_group)
	next_spawn_group += 1

	var explosion = explosion_scene.instance()
	explosion.position = (a1.position + a2.position) / 2
	call_deferred("add_child", explosion)

func shoot() -> void:
	var bullet = bullet_scene.instance()
	bullet.position = $player/tip.global_position
	bullet.velocity = Vector2(0, -300).rotated($player.rotation) + $player.velocity
	call_deferred("add_child_below_node", $HUD, bullet)
