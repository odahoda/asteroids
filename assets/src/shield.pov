#include "environment.pov"
#include "textures.inc"

background { colour srgbt <0.0, 0.0, 0.0, 1.0> }

difference
{
        sphere
        {
                <0, 0, 0>, 5 //(2*clock + 3)

                material
                {
                        texture
                        {
                                pigment { color rgbf<1, 1, 1, 1> }
                                finish { ambient 0 diffuse 0 }
                        }
                        interior
                        {
                                media
                                {
                                        emission color rgb 1
                                        //absorption 10
                                        intervals 5
                                        samples 1, 10
                                        confidence 0.9999
                                        variance 1/1000
                                        density
                                        {
                                                spherical
                                                ramp_wave
                                                turbulence 3 + 0.8 * sin(2*pi*clock)
                                                color_map
                                                {
                                                        [0.0 rgb <0.1, 0.1, 0>]
                                                        [0.1 rgb <0.2, 0.4, 0>]
                                                        [0.5 rgb <0.2, 0.8, 0.2>]
                                                        [0.95 rgb <0, 1, 0>]
                                                        [1.0 rgb <0, 0, 0>]
                                                }
                                        }
                                        scale 1*5 // (2*clock + 3)
                                        translate 2*y
                                }
                        }
                }
                hollow
                //texture { pigment { color rgb<0.8, 0.5, 0> } finish { phong 1 } }

                rotate 360*clock*z
        }

        sphere
        {
                <0, 0, 0>, 4.5
                scale <1, 0.8, 1>
        }

        box
        {
                <-10, -2, -10>, <10, -10 ,10>
        }
}
