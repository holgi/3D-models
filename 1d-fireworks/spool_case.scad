include <dimensions.scad>;


spool_inner_diameter      = 87.5;  // mm, measured
spool_inner_height        = 20.0;  // mm, measured
spool_inner_ring_height   =  5.0;  // mm, measured
spool_inner_ring_diameter = 50.0;  // mm, measured
spool_inner_width         =  1.5;  // mm, measured
spool_plate_height        =  4.5;  // mm, measured

spool_inner_net_height  = spool_inner_height - spool_inner_ring_height;
spool_outer_height      = spool_inner_height + spool_plate_height;

spool_case_strip_height = led_strip_width + 2;  // give a little leeway
spool_case_net_height   = spool_case_strip_height + spool_inner_net_height * 2;
spool_case_full_height  = spool_case_strip_height + spool_outer_height * 2;

spool_case_outer_diameter = spool_inner_diameter + spool_inner_width * 2;
spool_case_inset_diameter = spool_inner_diameter;


module spool_case_mockup() {
    cylinder(h=spool_case_strip_height, d=spool_case_outer_diameter, center=true);
    cylinder(h=spool_case_net_height,   d=spool_case_inset_diameter, center=true);
    cylinder(h=spool_case_full_height,  d=spool_inner_ring_diameter, center=true);
}

module spool_case_mockup_2d(quarter=false) {
    cut_size = 2 * [spool_case_full_height, spool_case_outer_diameter, spool_case_outer_diameter];
    projection()
        difference() {
            rotate([90, 0, 0])
                 spool_case_mockup();
        translate([-cut_size.x / 2, -cut_size.y,  -cut_size.z / 2])
            cube(cut_size);
        if (quarter) {
            translate([-cut_size.x, -cut_size.y / 2, -cut_size.z / 2])
                cube(cut_size);
        }
    }
}
translate([0,0,-1])
%spool_case_mockup_2d(quarter=true);

outer_radius = spool_case_outer_diameter / 2;
inset_radius = spool_case_inset_diameter / 2;
full_radius  = spool_inner_ring_diameter / 2;

half_strip_height = spool_case_strip_height / 2;
half_net_height   = spool_case_net_height / 2;
half_full_height  = spool_case_full_height / 2;

x0 = -0;
y0 = -0;

outer_polygon = [
    [x0,               y0],
    [outer_radius,     y0],
    [outer_radius,     half_strip_height - 1],
    [outer_radius - 1, half_strip_height-1],
    [outer_radius - 1, half_strip_height],
    [x0,               half_strip_height]
];
polygon(outer_polygon);
translate([outer_radius - 1, half_strip_height-1, 0])
    circle(r=1);

inset_polygon = [
    [x0,               y0],
    [inset_radius,     y0],
    [inset_radius,     half_net_height - 1],
    [inset_radius - 1, half_net_height-1],
    [inset_radius - 1, half_net_height],
    [x0,               half_net_height]
];

polygon(inset_polygon);
translate([inset_radius - 1, half_net_height-1, 0])
    circle(r=1);


full_polygon = [
    [x0,              y0],
    [full_radius,     y0],
    [full_radius,     half_full_height - 1],
    [full_radius - 1, half_full_height-1],
    [full_radius - 1, half_full_height],
    [x0,              half_full_height]
];

polygon(full_polygon);
translate([full_radius - 1, half_full_height-1, 0])
    circle(r=1);
