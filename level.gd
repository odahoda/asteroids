extends Node2D

signal finished

var aster_scene = preload("res://aster.tscn")
var explosion_scene = preload("res://explosion.tscn")
var bullet_scene = preload("res://bullet.tscn")
var player_scene = preload("res://player.tscn")
var player = null
var tick = 0.0
var wave = 1
var wave_start = true
var asters_to_spawn = 1
var spawn = 2
var next_spawn_group = 0
var score: int = 0
var health: int = 100
var animated_health: int = 100
onready var expl4_snd = [$expl4_snd1, $expl4_snd2, $expl4_snd3]
var expl4_snd_idx = 0
onready var music = [
	['res://assets/absolu.ogg', "absolute xtc by m0d"],
	['res://assets/the_digital_dragon.ogg', "The Digital Dragon by Drozerix"],
	['res://assets/miafan2010_-_aryx_remix_2012.ogg', "Aryx Remix 2012 by Katie Cadet"],
	['res://assets/pinkbats.ogg', "PinkBatsinSpace by JAM"],
]
var music_idx = 0

func _ready() -> void:
	randomize()

	var music_player = get_node('/root/game/music_player')
	if music_player != null:
		music_player.connect('finished', self, 'play_next_song')
		play_next_song()

	$HUD/score.text = "%s" % score
	animated_health = health
	$HUD/health.value = health

	player = player_scene.instance()
	add_child(player)
	player.position = get_viewport_rect().size / 2

	$HUD/announce.text = "Get Ready!"
	$HUD/announce/fade.play('fade')

func _process(delta: float) -> void:
	$HUD/health.value = animated_health

	if asters_to_spawn > 0:
		spawn -= delta
		if spawn <= 0:
			if wave_start:
				$HUD/announce.text = "Wave %d" % wave
				$HUD/announce/fade.play('fade')
				wave_start = false
			spawn = 3
			spawn_aster()
			asters_to_spawn -= 1
	elif player != null:
		tick += delta
		if tick > 1.0:
			tick = 0
			if asters_to_spawn == 0:
				var num_asters = len(get_tree().get_nodes_in_group("aster"))
				if num_asters == 0:
					wave += 1
					wave_start = true
					spawn = 3
					asters_to_spawn = wave

func _input(event):
	if event.is_action_pressed("ui_accept"):
		shoot()
	elif event.is_action_pressed("ui_cancel"):
		emit_signal('finished')

func play_next_song():
	var music_player = get_node('/root/game/music_player')
	music_player.play_song(music[music_idx][0])
	if get_node('/root/settings').get_music_volume() > 0:
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
		0,
		pos,
		Vector2(rand_range(50, 100), 0).rotated(dir),
		next_spawn_group)
	next_spawn_group += 1

func create_aster(size: int, pos: Vector2, vel: Vector2, spawn_group: int = 0) -> Aster:
	var aster = aster_scene.instance()
	aster.size = size
	aster.position = pos
	aster.vel = vel
	aster.spawn_group = spawn_group
	aster.add_to_group("aster")
	aster.connect('collided', self, 'handle_collision')
	call_deferred("add_child", aster)
	return aster

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
		play_expl4_snd(o2.size)
		inflict_damage(o2.mass)

		var explosion = explosion_scene.instance()
		explosion.position = o2.position
		explosion.vel = o2.vel
		call_deferred("add_child", explosion)
		o2.die()

	if o1 is Bullet and o2 is Aster:
		spawn_cluster(o2.size + 1, o2.position, o2.mass, o2.mass * o2.vel)
		collect_score(o2.mass)
		play_expl4_snd(o2.size)

		var explosion = explosion_scene.instance()
		explosion.position = o2.position
		explosion.vel = o2.vel
		call_deferred("add_child", explosion)
		o2.die()
		o1.queue_free()

func explode(a1: Aster, a2: Aster) -> void:
	var max_size = 0
	var min_size = 1000
	var pos = Vector2()
	var mass = 0
	var impulse = Vector2()
	for a in [a1, a2]:
		pos += a.position
		mass += a.mass
		impulse += a.mass * a.vel
		max_size = max(max_size, a.size)
		min_size = min(min_size, a.size)
	pos /= 2
	spawn_cluster(min_size + 1, pos, mass, impulse)

	var explosion = explosion_scene.instance()
	explosion.position = pos
	explosion.vel = impulse / mass
	call_deferred("add_child", explosion)

	play_expl4_snd(max_size)

func spawn_cluster(size: int, pos: Vector2, mass: int, impulse: Vector2):
	print(size, pos, mass, impulse)
	if size > 2:
		return

	var asters = []
	while mass > 0:
		var asize
		if size <= 0 and mass >= 100:
			asize = 0
			mass -= 100
		elif size <= 1 and mass >= 40:
			asize = 1
			mass -= 40
		else:
			asize = 2
			mass -= 15

		var aster = create_aster(asize, pos, Vector2(rand_range(100, 400), 0).rotated(rand_range(0, 2*PI)), next_spawn_group)
		asters.append(aster)
		impulse -= aster.mass * aster.vel

	for aster in asters:
		aster.vel += impulse / len(asters) / aster.mass

	next_spawn_group += 1

func play_expl4_snd(size: int) -> void:
	var snd = expl4_snd[expl4_snd_idx]
	expl4_snd_idx = (expl4_snd_idx + 1) % len(expl4_snd)
	snd.pitch_scale = 1.8 - size * 0.5 + rand_range(-0.1, 0.1)
	snd.play()
	
func shoot() -> void:
	if player == null:
		return

	var bullet = bullet_scene.instance()
	bullet.position = player.get_node('tip').global_position
	bullet.velocity = Vector2(0, -300).rotated(player.rotation) + player.velocity
	call_deferred("add_child_below_node", $HUD, bullet)
	$laser_snd.play()

func inflict_damage(damage: int) -> void:
	health = int(max(0, health - damage))
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
