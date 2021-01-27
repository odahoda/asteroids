#include "environment.pov"
#include "textures.inc"

background { colour srgbt <0.0, 0.0, 0.0, 1.0> }

#declare ball_texture = texture
{
        pigment { color rgbf <1, 0.6, 0, 0.6> }
        finish { phong 0.3 }
}

light_source
{
        <0, 0, 0>
        color rgb<10, 0, 0>
}

sphere
{
        <0, 0, 0>, 4
        texture { ball_texture }
}
