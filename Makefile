
export-all: export-linux export-windows

build-assets:
	$(MAKE) -C assets

build:
	mkdir -p build
	touch build/.nobackup

export-linux: build-assets build
	godot-headless --export "Linux/X11" build/asteroids-linux-x11.pck

export-windows: build-assets build
	godot-headless --export "Windows Desktop" build/asteroids-windows.pck

export-html5: build-assets build
	mkdir -p build/html5
	godot-headless --export "HTML5" build/html5/asteroids.html
