$fn = 60;

box_z_radius  = 1.0; // mm

led_strip_width  = 12.0;  // mm
led_strip_height =  4.0;  // mm

led_strip_clutch_length =  5.0;  // mm
led_strip_clutch_height =  1.5;  // mm

led_strip_end_length    = 22.0;  // mm
led_strip_end_width     = 14.0;  // mm
led_strip_end_height    =  6.5;  // mm

wire_diameter      =  1.8;  // mm
wire_length        = 90.0;   // mm
wire_sort_distance = 15.0;   // mm


wire_clutch_width  =  9.0;  // mm
wire_clutch_length = 15.0;  // mm
wire_clutch_height = wire_diameter;  // mm


wall_width    = 3.0; // mm
bottom_height = 2.0; //mm


hook_outer_diameter = 45.0; // mm
hook_inner_diameter = 25.0; // mm


screws_shaft = 3.0; //mm

screw_shaft_diameter = 3.0; // mm
screw_head_diameter  = 5.5; // mm
screw_head_height    = 3.0; // mm
screw_nut_diameter   = 6.0; // mm
screw_nut_height     = 2.2; // mm

screw_hole_slack     = 0.2; // mm

screw_pillar_diameter = screw_nut_diameter +  2 * wall_width;
screw_pillar_radius   = screw_pillar_diameter / 2;

hook_box_inner_height = 14.0; // mm

wire_clutch_assembly_offset    = 15; // mm
wire_clutch_clamp_width        =  5.0; // mm
wire_clutch_clamp_slide_length =  5.0; // mm


module rounded_edge(length=20, radius=5, slack=0.25) {
    translate([-radius/2, -radius/2, -length/2])
        difference() {
            cube([radius + slack, radius + slack, length]);
            translate([0,0, -1])
                cylinder(length+2, r=radius);
        }
}
