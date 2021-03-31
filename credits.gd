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

extends Container

onready var text = $'text';

func _ready() -> void:
	var f = File.new()
	f.open("res://credits.txt", File.READ)
	text.bbcode_text = f.get_as_text()
	f.close()
	var h = text.rect_size.y
	text.margin_bottom = rect_size.y + h
	text.margin_top = rect_size.y

func _process(delta: float) -> void:
	var h = text.rect_size.y
	text.margin_top -= 50 * delta
	if -text.margin_top > text.rect_size.y:
		text.margin_top = rect_size.y
	text.margin_bottom = text.margin_top + h
