#declare pship_height = 1.5;

#declare pship_phase = 0;

#ifdef ( anim_mode )
    #if ( clock > 1.0 )
	#declare pship_phase = 1;
    #end
#end

#declare pship_black_texture = texture
{
    pigment { color rgb <0, 0, 0> }
    finish { diffuse 0 ambient 0 phong 0 }
}

#declare pship_body_texture = texture
{
    #if ( pship_phase = 1 )
	pship_black_texture
    #else
	pigment { color rgb <0.5, 0.5, 0.5> }
	finish { /*ambient 0.4*/ phong 0.7 }
    #end
}

#declare pship_body = sphere
{
    <0, 0, 0>, 1.2
    scale <1, 0.7, 4 / 1.2>
    texture { pship_body_texture }
}

#declare pship_wing = union
{
    union
    {
	prism
	{
	    conic_sweep
	    cubic_spline
	    0.6, 1, 7,
	    <-0.3, -0.3>,
	    <1, 0>,
	    <-0.1, 0.2>,
	    <-1, 0>,
	    <-0.3, -0.3>,
	    <1, 0>,
	    <-0.1, 0.2>
	    rotate <180, 0, 0>
	    translate <0, 1, 0>
	    rotate 90*x
	    rotate 90*y
	    scale <4 / 0.4, 1, 1>
	}

	sphere
	{
	    <4, 0, 0>, 0.3
	    scale <1, 1, 1.5 / 0.3>
	    translate 0.3*z
	}

	matrix < 1, 0, -0.4,
	0, 1, 0,
	0, 0, 1,
	0, 0, 0 >
	rotate <0, 0, -8>
    }

    prism
    {
	conic_sweep
	cubic_spline
	0.6, 1, 7,
	<-0.3, -0.3>,
	<1, 0>,
	<-0.1, 0.2>,
	<-1, 0>,
	<-0.3, -0.3>,
	<1, 0>,
	<-0.1, 0.2>
	rotate <180, 0, 0>
	translate <0, 1, 0>
	rotate 90*x
	rotate 90*y
	scale <2 / 0.4, 1, 0.6>
	matrix < 1, 0, -0.2,
	0, 1, 0,
	0, 0, 1,
	0, 0, 0 >
	rotate <0, 0, 25>
	translate 0.3*y
    }

    translate <1, -0.2, -0.7>
    texture { pship_body_texture }
}

#declare pship_left_wing = object {
    pship_wing
}

#declare pship_right_wing = object {
    pship_wing
    scale <-1, 1, 1>
}

#declare pship_upper_fin = prism {
    conic_sweep
    cubic_spline
    0.6, 1, 7,
    <-0.3, -0.3>,
    <1, 0>,
    <-0.1, 0.2>,
    <-1, 0>,
    <-0.3, -0.3>,
    <1, 0>,
    <-0.1, 0.2>
    rotate <180, 0, 0>
    translate <0, 1, 0>
    rotate 90*x
    rotate 90*y
    scale <2 / 0.4, 1, 0.6>
    matrix < 1, 0, -0.2,
    0, 1, 0,
    0, 0, 1,
    0, 0, 0 >
    rotate <0, 0, 90>
    translate <0, 0, -3.6>
    texture { pship_body_texture }
}

#declare pship_lower_fin = union
{
    prism
    {
	conic_sweep
	cubic_spline
	0.6, 1, 7,
	<-0.3, -0.3>,
	<1, 0>,
	<-0.1, 0.2>,
	<-1, 0>,
	<-0.3, -0.3>,
	<1, 0>,
	<-0.1, 0.2>
	rotate <180, 0, 0>
	translate <0, 1, 0>
	rotate 90*x
	rotate 90*y
	scale <1.5 / 0.4, 1, 0.6>
	matrix < 1, 0, -0.4,
	0, 1, 0,
	0, 0, 1,
	0, 0, 0 >
	rotate <0, 0, -130>
    }

    prism
    {
	conic_sweep
	cubic_spline
	0.6, 1, 7,
	<-0.3, -0.3>,
	<1, 0>,
	<-0.1, 0.2>,
	<-1, 0>,
	<-0.3, -0.3>,
	<1, 0>,
	<-0.1, 0.2>
	rotate <180, 0, 0>
	translate <0, 1, 0>
	rotate 90*x
	rotate 90*y
	scale <1.5 / 0.4, 1, 0.6>
	matrix < 1, 0, -0.4,
	0, 1, 0,
	0, 0, 1,
	0, 0, 0 >
	rotate <0, 0, -50>
    }

    translate <0, 0, -3.6>
    texture { pship_body_texture }
}

#declare pship_single_turbine = union
{
    cylinder
    {
	<0, 0, -3>, <0, 0, -4.5>, 0.25
	open
	texture
	{
	    pigment { color rgb <0.1, 0.1, 0.1> }
	}
    }

    lathe
    {
	quadratic_spline
	8
	<0, 0.01>
	<0.023, 0.03>
	<0.039, 0.055>
	<0.043, 0.09>
	<0.033, 0.13>
	<0.02, 0.164>
	<0.01, 0.193>
	<0, 0.25>

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
		    emission color rgb 25*<1, 0.4, 0>
		    absorption 10
		    intervals 5
		    samples 1, 10
		    confidence 0.9999
		    variance 1/1000
		    density
		    {
			spherical
			ramp_wave
			#ifdef ( pship_turbine_on )
			    turbulence 1.5
			#else
			    turbulence 1 + clock
			#end
			color_map
			{
			    [0.0 color rgb <0, 0, 0>]
			    [0.1 color rgb <0, 0, 1>]
			    [0.2 color rgb <1, 0.5, 0>]
			    [1.0 color rgb <1, 0, 0>]
			}
		    }
		    #ifdef ( pship_turbine_on )
			scale <0.04, 0.18, 0.04>
		    #else
			scale <0.04, 0.13 + 0.05 * (clock - 1), 0.04>
		    #end
		}
	    }
	}
	hollow

	rotate -90*x
	scale 10
	translate <0, 0, -4.1>
    }
}

#declare pship_turbine = union
{
    object
    {
	pship_single_turbine
	translate <0, 0.25, 0>
    }
    object
    {
	pship_single_turbine
	translate <0.22, -0.175, 0>
    }
    object
    {
	pship_single_turbine
	translate <-0.22, -0.175, 0>
    }
}

#declare pship_cockpit = sphere
{
    <0, 0, 0> 0.5
    scale <1, 1, 1 / 0.5>
    rotate 8*x
    translate <0, 0.58, 1.5>
    texture
    {
	#if ( pship_phase = 1 )
	    pship_black_texture
	#else
	    pigment { color rgb <0, 0, 1> }
	    finish { phong 1.0 }
	#end
    }
}

#declare pship_gun = union
{
    cylinder
    {
	<0.6, -0.4, 2> <0.6, -0.4, 3.8> 0.12
    }

    cylinder
    {
	<-0.6, -0.4, 2> <-0.6, -0.4, 3.8> 0.12
    }

    texture
    {
	#if ( pship_phase = 1 )
	    pship_black_texture
	#else
	    pigment { color rgb <0.1, 0.1, 0.1> }
	#end
    }
}

#ifdef ( pship_leg_state )
    #declare pship_leg = difference
    {
	merge
	{
	    cylinder
	    {
		<0, 0, 0>, <0, -1.1, 0.8>, 0.05
	    }

	    difference
	    {
		sphere
		{
		    <0, -1.1, 0.8>, 0.2
		}

		box
		{
		    <-2, -1.1, 0>, <2, -2, 2>
		}
	    }

	    translate -<0, -1.1, 0.8> * (1 - pship_leg_state)
	    rotate -45 * (1 - pship_leg_state) * x

	    texture { pship_body_texture }
	}

	merge
	{
	    box { <-2, 0, -10>, <2, 10, 10> }
	    box { <-2, -10, 0>, <2, 0, -10> }
	}
    }

    #declare pship_legs = merge
    {
	object { pship_leg translate <0, -0.4, 3> }
	object { pship_leg rotate 120*y translate <1, -0.4, -1> }
	object { pship_leg rotate -120*y translate <-1, -0.4, -1> }
    }
#end

#declare pship = union {
    object { pship_body }
    object { pship_left_wing }
    object { pship_right_wing }
    #if ( pship_phase = 0 )
	object { pship_upper_fin }
	object { pship_lower_fin }
    #end
    #if ( pship_phase = 1 )
	object { pship_turbine }
    #end
    #ifdef ( pship_turbine_on )
	object { pship_turbine }
    #end
    object { pship_cockpit }
    object { pship_gun }
    #ifdef ( pship_leg_state )
	object { pship_legs }
    #end
}
