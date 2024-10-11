$fn = 60;

// led strip

led_strip_width         = 12.0;  // mm
led_strip_height        =  4.0;  // mm

led_strip_clutch_length =  5.0;  // mm
led_strip_clutch_height =  1.5;  // mm

led_strip_end_length    = 22.0;  // mm
led_strip_end_width     = 14.0;  // mm
led_strip_end_height    =  6.5;  // mm

led_wire_diameter       =  1.8;  // mm
led_wire_length         = 90.0;   // mm
led_wire_sort_distance  = 15.0;   // mm

led_wire_clutch_width   =  9.0;  // mm
led_wire_clutch_length  = 15.0;  // mm
led_wire_clutch_height  = led_wire_diameter;  // mm

led_length_requirements = (
      led_strip_clutch_length  // led clutch area
    + led_strip_end_length     // led end cap
    + led_wire_sort_distance   // sorting the wires to a ribbon cable
    + led_wire_sort_distance   // clamping the wires down
    + led_wire_sort_distance   // bending the wires around
);

// cases

case_wall      =  3.0; // mm
case_plate     =  2.0; // mm
case_z_radius  =  1.0; // mm, horizontal edge radius


// screws - M3 machine screws, roughly measured

screw_shaft_diameter = 3.0; // mm
screw_head_diameter  = 5.5; // mm
screw_head_height    = 3.0; // mm

screw_nut_diameter   = 6.0; // mm
screw_nut_height     = 2.2; // mm

screw_hole_slack     = 0.2 * 2; // mm


screw_pillar_diameter = screw_nut_diameter +  2 * case_wall;
screw_pillar_radius   = screw_pillar_diameter / 2;
screw_shaft_radius    = screw_shaft_diameter / 2;


// hook case

hook_case_outer = [
    led_strip_end_width + 2 * screw_pillar_diameter,
    led_length_requirements + case_wall,            // only one, the second is used to clutch the led strip
    20.0 // mm                                      // depends mainly on available screw lengths
];

hook_case_inner = hook_case_outer - 2 * [case_wall, case_wall, case_plate];
hook_case_pillar_center = hook_case_outer - [screw_pillar_diameter, screw_pillar_diameter, screw_pillar_diameter];


// the wire clutch for a case

wire_clutch_clamp_block_width  =  5.0; // mm
wire_clutch_clamp_slide_length =  5.0; // mm
wire_clutch_assembly_offset    = led_length_requirements - 2 * led_wire_sort_distance;





module rounded_edge(length=20, radius=5, slack=0.25) {
    offset_vector = [radius, radius, length] / 2;
    translate(-offset_vector)
        difference() {
            cube([radius + slack, radius + slack, length]);
            translate([0, 0, -1])
                cylinder(length + 2, r=radius);
        }
}

