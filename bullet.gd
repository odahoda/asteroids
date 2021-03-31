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

class_name Bullet
extends Area2D

var velocity = Vector2(100, 0)
var lifetime = 0.0

func _ready() -> void:
	pass

func _process(delta: float) -> void:
	lifetime += delta
	if lifetime > 2.0 and not $animations.is_playing():
		$animations.play('fade')
		var _unused = $animations.connect('animation_finished', self, '__faded', [], CONNECT_ONESHOT)

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

func __faded(_anim) -> void:
	queue_free()
