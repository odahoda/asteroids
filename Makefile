
export-all: export-linux export-windows

build-assets:
	$(MAKE) -C assets

build:
	mkdir -p build
	touch build/.nobackup

export-linux: build-assets build
	mkdir -p build/linux-x11
	godot-headless --export "Linux/X11" build/linux-x11/asteroids-$$(cat version)

export-windows: build-assets build
	mkdir -p build/windows
	godot-headless --export "Windows Desktop" build/windows/asteroids-$$(cat version).exe

export-html5: build-assets build
	mkdir -p build/html5
	godot-headless --export "HTML5" build/html5/asteroids.html
