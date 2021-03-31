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

class_name Aster
extends Area2D

signal collided

var vel: Vector2 = Vector2()
var size: int setget __set_size, __get_size
var mass: int = 0
var shape: String = 'big'
var spawn_group: int = 0
var dead = false
var lifetime = 0.0

func _ready() -> void:
	$sprite.animation = shape
	if shape == 'big':
		$collision_big.disabled = false
	elif shape == 'medium':
		$collision_medium.disabled = false
	else:
		$collision_small.disabled = false

	$sprite.speed_scale = rand_range(0.5, 1.5)
	$animation.playback_speed = rand_range(-5, 5)
	$animation.play("rotation")

func _process(delta: float) -> void:
	lifetime += delta
	if lifetime > 0.3:
		spawn_group = 0

	position += vel * delta

	var screen = get_viewport_rect().size
	if position.x < -32:
		position.x = screen.x + 32
	elif position.x >= screen.x + 32:
		position.x = -32
	if position.y < -32:
		position.y = screen.y + 32
	elif position.y >= screen.y + 32:
		position.y = -32

func _on_Area2D_area_entered(area: Area2D) -> void:
	if not dead:
		emit_signal('collided', self, area)

func die():
	dead = true
	$collision_big.set_deferred('disabled', true)
	$collision_medium.set_deferred('disabled', true)
	$collision_small.set_deferred('disabled', true)
	queue_free()

func __get_size() -> int:
	return size

func __set_size(s: int) -> void:
	assert(0 <= s and s <= 2)
	size = s
	if size == 0:
		mass = 100
		shape = 'big'
	elif size == 1:
		mass = 40
		shape = 'medium'
	else:
		mass = 15
		shape = 'small'

func __get_mass() -> int:
	return mass

func __get_shape() -> String:
	return shape
