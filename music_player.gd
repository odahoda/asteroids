# Copyright (c) 2021, Ben Niemann <pink@odahoda.de>
#
# This program is free software; you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation; either version 2 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License along
# with this program; if not, write to the Free Software Foundation, Inc.,
# 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA.

extends AudioStreamPlayer

var song_list = null
var current_song = null
var mutex = null
var thread = null
onready var fade = $fade

func _ready() -> void:
	mutex = Mutex.new()

func fade_out():
	var previous_song = stream
	if stream != null:
		fade.interpolate_property(self, 'volume_db', 0.0, -40.0, 0.5, Tween.TRANS_LINEAR)
		fade.start()
		yield (fade, 'tween_all_completed')
		stop()
		stream = null
		if previous_song != null:
			previous_song.queue_free()
	mutex.lock()
	current_song = null
	mutex.unlock()

func play_song(path):
	if thread != null:
		thread.wait_to_finish()

	mutex.lock()
	var is_new = current_song != path
	mutex.unlock()
	if not is_new:
		return

	thread = Thread.new()
	thread.start(self, "__loader", path)

func __loader(path):
	if stream != null:
		fade.interpolate_property(self, 'volume_db', 0.0, -40.0, 0.5, Tween.TRANS_LINEAR)
		fade.start()

	print("Loading song %s" % path)
	var t1 = OS.get_system_time_msecs()
	var song = load(path)
	var t2 = OS.get_system_time_msecs()
	print("Resource loaded in %dmsec" % (t2 - t1))
	while fade.is_active():
		OS.delay_usec(16000)
	var previous_song = stream
	if stream != null:
		stop()
		stream = null
	print("Start playback of %s" % path)
	mutex.lock()
	current_song = path
	mutex.unlock()
	stream = song
	volume_db = 0.0
	play()

	if previous_song != null:
		previous_song.queue_free()

	print("Loader done.")
