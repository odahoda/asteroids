extends Node2D

signal finished

var aster_scene = preload("res://aster.tscn")
var explosion_scene = preload("res://explosion.tscn")
var bullet_scene = preload("res://bullet.tscn")
var player_scene = preload("res://player.tscn")
var player = null
var spawn
var next_spawn_group = 0
var score: int = 0
var health: int = 100
var animated_health: int = 100
onready var expl4_snd = [$expl4_snd1, $expl4_snd2, $expl4_snd3]
var expl4_snd_idx = 0
onready var music = [
	[$music1, "absolute xtc by m0d"],
	[$music2, "The Digital Dragon by Drozerix"],
	[$music3, "Aryx Remix 2012 by Katie Cadet"],
	[$music4, "PinkBatsinSpace by JAM"],
]
var music_idx = 0

func _ready() -> void:
	randomize()
	
	var m = range(len(music))
	m.shuffle()
	play_next_song()

	spawn = 0.0
	score = 0
	$HUD/score.text = "%s" % score
	health = 100
	animated_health = health
	$HUD/health.value = health

	player = player_scene.instance()
	add_child(player)
	player.position = get_viewport_rect().size / 2

	$HUD/announce.text = "Get Ready!"
	$HUD/announce/fade.play('fade')

func _process(delta: float) -> void:
	$HUD/health.value = animated_health

func _physics_process(delta: float) -> void:
	spawn -= delta
	if spawn <= 0:
		spawn = 3
		spawn_aster()

func _input(event):
	if event.is_action_pressed("ui_accept"):
		shoot()
	elif event.is_action_pressed("ui_cancel"):
		emit_signal('finished')

func play_next_song():
	var n = music[music_idx][0]
	n.play()
	n.connect('finished', self, 'play_next_song', [], CONNECT_ONESHOT)
	$HUD/songinfo.text = music[music_idx][1]
	$HUD/songinfo/fade.play('fade')
	music_idx = (music_idx + 1) % len(music)

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
	if o1 is Aster and o2 is Aster and (o1.spawn_group == 0 or o1.spawn_group != o2.spawn_group):
		explode(o1, o2)
		o1.die()
		o2.die()
		
	if o2 is Player or o2 is Bullet:
		var t = o1
		o1 = o2
		o2 = t

	if o1 is Player and o2 is Aster:
		var size
		var damage
		if o2.shape == 'big':
			size = 2
			damage = 100
		elif o2.shape == 'medium':
			size = 1
			damage = 40
		else:
			size = 0
			damage = 15

		play_expl4_snd(size)
		inflict_damage(damage)

		var explosion = explosion_scene.instance()
		explosion.position = o2.position
		call_deferred("add_child", explosion)
		o2.die()

	if o1 is Bullet and o2 is Aster:
		var size
		if o2.shape == 'big':
			create_aster('medium', o2.position, Vector2(rand_range(100, 400), 0).rotated(rand_range(0, 2*PI)), next_spawn_group)
			create_aster('medium', o2.position, Vector2(rand_range(100, 400), 0).rotated(rand_range(0, 2*PI)), next_spawn_group)
			collect_score(50)
			size = 2
		elif o2.shape == 'medium':
			create_aster('small', o2.position, Vector2(rand_range(100, 400), 0).rotated(rand_range(0, 2*PI)), next_spawn_group)
			create_aster('small', o2.position, Vector2(rand_range(100, 400), 0).rotated(rand_range(0, 2*PI)), next_spawn_group)
			collect_score(20)
			size = 1
		else:
			collect_score(10)
			size = 0
		next_spawn_group += 1

		play_expl4_snd(size)

		var explosion = explosion_scene.instance()
		explosion.position = o2.position
		call_deferred("add_child", explosion)
		o2.die()
		o1.queue_free()

func explode(a1: Aster, a2: Aster) -> void:
	var size = 0
	for a in [a1, a2]:
		if a.shape == 'big':
			size = max(size, 2)
			create_aster('medium', a.position, Vector2(rand_range(100, 400), 0).rotated(rand_range(0, 2*PI)), next_spawn_group)
			create_aster('medium', a.position, Vector2(rand_range(100, 400), 0).rotated(rand_range(0, 2*PI)), next_spawn_group)
			create_aster('small', a.position, Vector2(rand_range(200, 300), 0).rotated(rand_range(0, 2*PI)), next_spawn_group)
			create_aster('small', a.position, Vector2(rand_range(200, 300), 0).rotated(rand_range(0, 2*PI)), next_spawn_group)
		elif a.shape == 'medium':
			size = max(size, 1)
			create_aster('small', a.position, Vector2(rand_range(100, 400), 0).rotated(rand_range(0, 2*PI)), next_spawn_group)
			create_aster('small', a.position, Vector2(rand_range(100, 400), 0).rotated(rand_range(0, 2*PI)), next_spawn_group)
			create_aster('small', a.position, Vector2(rand_range(100, 400), 0).rotated(rand_range(0, 2*PI)), next_spawn_group)
		else:
			size = max(size, 0)
	next_spawn_group += 1

	var explosion = explosion_scene.instance()
	explosion.position = (a1.position + a2.position) / 2
	call_deferred("add_child", explosion)

	play_expl4_snd(size)

func play_expl4_snd(size: int) -> void:
	var snd = expl4_snd[expl4_snd_idx]
	expl4_snd_idx = (expl4_snd_idx + 1) % len(expl4_snd)
	snd.pitch_scale = 1.8 - size * 0.5 + rand_range(-0.1, 0.1)
	snd.play()
	
func shoot() -> void:
	var bullet = bullet_scene.instance()
	bullet.position = player.get_node('tip').global_position
	bullet.velocity = Vector2(0, -300).rotated(player.rotation) + player.velocity
	call_deferred("add_child_below_node", $HUD, bullet)
	$laser_snd.play()

func inflict_damage(damage: int) -> void:
	health = max(0, health - damage)
	if health == 0:
		call_deferred('die')

	var tween = $HUD/health/tween
	tween.interpolate_property(self, "animated_health", animated_health, health, 0.6)
	if not tween.is_active():
		tween.start()

func die() -> void:
	var pos = player.position
	player.queue_free()
	player = null

	for i in range(8):
		var explosion = explosion_scene.instance()
		explosion.position = pos + Vector2(0, rand_range(0, 50)).rotated(rand_range(0, 2*PI))
		add_child(explosion)
		play_expl4_snd(2)
		yield(get_tree().create_timer(0.05 * (i + 5)), 'timeout')

	$HUD/announce.text = "Game Over!"
	$HUD/announce/fade.play('fade')
	yield($HUD/announce/fade, 'animation_finished')

	yield(get_tree().create_timer(1.0), 'timeout')
	emit_signal('finished')
