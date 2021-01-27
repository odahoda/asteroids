#include "environment.pov"
#include "textures.inc"

sphere
{       
        <0, 0, 0>, 5

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
                                emission color rgb 0.3 - 0.2 * clock
                                //absorption 10
                                intervals 5
                                samples 1, 10
                                confidence 0.9999
                                variance 1/1000
                                density 
                                {
                                        spherical
                                        ramp_wave
                                        turbulence 0.2 + 0.6*clock
                                        color_map 
                                        {
                                                [0.0 rgb <0, 0, 0>]
                                                [0.1 - 0.05*clock rgb <0.3, 0.3, 0.4>]
                                                [0.5 - 0.3*clock rgb <0.5, 0.5, 0.6>]
                                                [0.95 - 0.7*clock rgb <0.7, 0.7, 0.7>]
                                                [0.98 - 0.65*clock rgb<0, 0, 0>]
                                                [1.0 rgb <0, 0, 0>]
                                        }
                                }
                                scale 0.7*5
                                //scale <0.04, 0.2 + 0.05 * cos(radians(clock * 360)), 0.04>
                        }
                }
        }                
        hollow
        //texture { pigment { color rgb<0.8, 0.5, 0> } finish { phong 1 } }
        rotate <40, -30, -10>*(clock+2)
}
