#include "environment.pov"
#include "textures.inc"

background { colour srgbt <0.0, 0.0, 0.0, 1.0> }

mesh
{
        #include "aster1-tri.pov"

        texture
        {
                pigment { color rgb<0.58, 0.38, 0.21> }
                finish { phong 0.1 diffuse 0.4 }
        }

        scale 0.9
        rotate 360*clock*x
        rotate 20*y
        rotate 10*z
}
