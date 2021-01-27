global_settings { assumed_gamma 2.2 }

#include "colors.inc"

camera {
  location <0, 12, 0>
  look_at <0, 0, 0>
  up z
  right x
}

light_source { <-12, 12, 12> color rgb <3, 3, 3> }
light_source { <12, 5, 8> color rgb <1, 0.9, 0.7> }

//light_source { <-120, 120, 120> colour White }
//light_source { <120, 120, -120> colour White }
//light_source { <-120, 120, -120> colour White }

background { color Black }

#declare axis = union
{
        sphere
        {
                <0, 0, 0>, 0.2
                texture
                {
                        pigment { color rgb <1, 0, 0> }
                        finish { ambient 0.4 phong 0.7 }
                }
        }
        
        cylinder 
        {
                <0, 0, 0>, <10, 0, 0>
                0.05 
                texture
                {
                        pigment { color rgb <0, 1, 0> }
                        finish { ambient 0.4 phong 0.7 }
                }
        } 
        
        cylinder 
        {
                <0, 0, 0>, <0, 10, 0>
                0.05 
                texture
                {
                        pigment { color rgb <0, 1, 0> }
                        finish { ambient 0.4 phong 0.7 }
                }
        } 
        
        cylinder 
        {
                <0, 0, 0>, <0, 0, 10>
                0.05 
                texture
                {
                        pigment { color rgb <0, 1, 0> }
                        finish { ambient 0.4 phong 0.7 }
                }
        } 
}
