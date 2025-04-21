// original dimensions

$fn=60;

outer_lower_diameter = 68.0;  // mm

outer_upper_diameter = 69.5;  // mm
inner_upper_diameter = 66.0;  // mm

inner_rim_height     =  1.0;  // mm
inner_rim_width      =  1.5;  // mm

bottom_hole_diameter =  7.0;  // mm
bottom_cutout_width  =  4.0;  // mm

bottom_width         =  1.3;  // mm
wall_width           =  2.0;  // mm



height               =  5.0;  // mm


inner_lower_diameter = outer_lower_diameter - bottom_width * 2;
bottom_inset_cutout  = bottom_cutout_width  + inner_rim_width * 2;
bottom_inset_hole    = bottom_hole_diameter + inner_rim_width * 2;

difference() {
    cylinder(d=inner_lower_diameter, h=height, center=true);
        cube([bottom_inset_cutout, outer_lower_diameter, height+1], center=true);
        cylinder(d=bottom_inset_hole, h=height+1, center=true);
}
