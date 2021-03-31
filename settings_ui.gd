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

extends Control

signal done

var settings = null

onready var done_button = $done
onready var fullscreen_button = $grid/fullscreen
onready var music_volume_slider = $grid/music_volume
onready var sound_volume_slider = $grid/sound_volume

func _ready() -> void:
	settings = get_node('/root/settings')

	done_button.connect('button_up', self, 'fade_out')

	fullscreen_button.pressed = settings.get_fullscreen()
	fullscreen_button.connect('toggled', settings, 'set_fullscreen')
	music_volume_slider.value = settings.get_music_volume()
	music_volume_slider.connect('value_changed', settings, 'set_music_volume')
	sound_volume_slider.value = settings.get_sound_volume()
	sound_volume_slider.connect('value_changed', settings, 'set_sound_volume')
	fade_in()

func _input(event):
	if event.is_action_pressed("ui_cancel"):
		done_button.grab_focus()
		fade_out()

func fade_in() -> void:
	$animations.play('fade_in')
	$animations.seek(0, true)

func fade_out() -> void:
	$animations.play('fade_out')
	var _unused = $animations.connect('animation_finished', self, '__fade_out_finished', [], CONNECT_ONESHOT)

func __fade_out_finished(_anim) -> void:
	settings.save_settings()
	emit_signal('done')
