all: aster1.png aster2.png aster3.png smoke1.png pship.png ball1.png

aster1.png: src/aster1.ini src/aster1.pov src/aster1-tri.pov
	povray +FP +V +Lsrc/ 'src/aster1.ini[final]' +Isrc/aster1.pov +O/tmp/aster1-
	convert -append /tmp/aster1-*.png aster1.png
	rm -f /tmp/aster1-*.png

aster2.png: src/aster2.ini src/aster2.pov src/aster2-tri.pov
	povray +FP +V +Lsrc/ 'src/aster2.ini[final]' +Isrc/aster2.pov +O/tmp/aster2-
	convert -append /tmp/aster2-*.png aster2.png
	rm -f /tmp/aster2-*.png

aster3.png: src/aster3.ini src/aster3.pov src/aster3-tri.pov
	povray +FP +V +Lsrc/ 'src/aster3.ini[final]' +Isrc/aster3.pov +O/tmp/aster3-
	convert -append /tmp/aster3-*.png aster3.png
	rm -f /tmp/aster3-*.png

smoke1.png: src/smoke1.ini src/smoke1.pov
	povray +FP +V +Lsrc/ 'src/smoke1.ini[final]' +Isrc/smoke1.pov +O/tmp/smoke1-
	convert -size 128x128 xc:none /tmp/smoke1-32.png
	convert -append /tmp/smoke1-*.png smoke1.png
	rm -f /tmp/smoke1-*.png

pship.png: src/pship.ini src/pship.pov src/pship-obj.pov
	povray +FP +V +Lsrc/ 'src/pship.ini[final]' +Isrc/pship.pov +Opship

ball1.png: src/ball1.ini src/ball1.pov
	povray +FP +V +Lsrc/ 'src/ball1.ini[final]' +Isrc/ball1.pov +Oball1
