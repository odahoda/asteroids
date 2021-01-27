#include "environment.pov"
#include "textures.inc"

#declare anim_mode = 1;
#include "pship-obj.pov"

background { colour srgbt <0.0, 0.0, 0.0, 1.0> }

object {
        pship
        translate <0, 0, 1.2>
        scale 1.1

#if ( clock <= 1.0 )
        rotate -40*(clock - 0.5)*z
        rotate 10*(clock - 0.5)*y
        translate 2*(clock - 0.5)*x
#end
}
