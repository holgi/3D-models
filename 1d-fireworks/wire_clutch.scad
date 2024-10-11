include <dimensions.scad>;
include <case.scad>;



module wire_clutch() {

    channel_width  = led_wire_clutch_width;
    channel_length = led_wire_clutch_length;
    channel_height = led_wire_clutch_height;

    base_width        = hook_case_inner.x - 1;  // 1 mm slack
    thick_part_width  = channel_width  + case_wall * 2;
    thick_part_height = channel_height + case_wall;

    base_vector  = [base_width,       channel_length, led_strip_clutch_height];
    thick_vector = [thick_part_width, channel_length, thick_part_height];

    edge_length  = thick_part_width + 2;

    difference() {
        union() {
            // base
            translate([0, 0, base_vector.z / 2])
                box(base_vector, vertical_radius=2, horizontal_radius=0, center=true);
            // thicker part
            translate([0, 0, thick_vector.z / 2])
                cube(thick_vector, center=true);
        }

        // nice round upper edge 1
        translate([thick_vector.x / 2 - 1, 0, thick_vector.z - 1])
            rotate([90, 0, 0])
                rounded_edge(edge_length, radius=2 );

        // nice round upper edge 2
        translate([-thick_vector.x / 2 + 1, 0, thick_vector.z - 1])
            rotate([-90, 180, 0])
                rounded_edge(edge_length, radius=2 );

        // channel for the wires
        translate([0, 0, channel_height / 2 - 1])
            cube([channel_width, channel_length + 2, channel_height + 2], center=true);

        // nice round channel edge 1
        translate([-(channel_width + channel_height) / 2, 0, channel_height / 2])
            rotate([-90, 0, 0])
                rounded_edge(edge_length, radius=channel_height );

        // nice round channel edge 2
        translate([(channel_width + channel_height) / 2, 0, channel_height / 2])
            rotate([90, 180, 0])
                rounded_edge(edge_length, radius=channel_height );

    }

}

module clutch_clamp() {

    channel_width  = led_wire_clutch_width;
    channel_length = led_wire_clutch_length;
    channel_height = led_wire_clutch_height;

    slide_length     = wire_clutch_clamp_slide_length;
    block_length     = wire_clutch_clamp_slide_length * 2;
    block_width      = wire_clutch_clamp_block_width;
    height           = led_strip_clutch_height + case_wall;

    nice_radius      = led_strip_clutch_height;
    half_nice_radius = nice_radius / 2;

    difference() {
        // full block to start with
        translate([-block_width / 2, -block_length / 2,         -1])
            cube( [ block_width    ,  block_length    , height + 1]);

        // make a slight slide edge
        translate([0, 0, led_strip_clutch_height])
            for(angle=[0, 7]) {
                rotate([angle, 0, 0])
                    translate([-block_width / 2 - 1, 0               , -height])
                        cube( [ block_width     + 2, slide_length + 1,  height]);
            }

        // some nice round edges, part 1
        translate([0, -slide_length + half_nice_radius, height - half_nice_radius])
            rotate([90, -90, 90])
                rounded_edge(block_width + 2, radius=nice_radius);

        // some nice round edges, part 2
        // custom aligned for the sloped edge
        translate([0, slide_length - half_nice_radius, 2.65])
            rotate([90, 90, 90])
                rounded_edge(block_width + 2, radius=nice_radius);
    }
}

module wire_clutch_press(outer_dimensions, case_cut_height) {

    inner_dimensions = outer_dimensions - 2 * [case_wall, case_wall, case_plate];

    lower_case_inner_height = case_cut_height - case_plate;
    upper_case_inner_height = inner_dimensions.z - lower_case_inner_height;

    wire_clutch_press_length = 14; // manually set by playing around in OpenScad
    wire_clutch_press_height = inner_dimensions.z - led_wire_clutch_height;
    wire_clutch_press_width  = (
          inner_dimensions.x    // available room
        - led_wire_clutch_width // the width of the thick wire clutch section, part 1
        - 2 * case_wall         // the width of the thick wire clutch section, part 1
    ) / 2 - 1.5;                // devide by two side and leave a little bit wiggle room

    protrusion_x = case_wall - case_z_radius;
    protrusion_z = lower_case_inner_height - led_wire_clutch_height;
    protrusion_case = case_plate - case_z_radius;

    press_dimensions = [
        wire_clutch_press_width,
        wire_clutch_press_length,
        wire_clutch_press_height
    ];

    // this looks now weird,
    // but the rounded_cube() module is picky if
    // the horizontal radius is larger than vertical radius
    // and the z-dimension is elongated to
    // cut off the rounded corner and to reach into the base plate
    press_dimensions_rotated = [
        press_dimensions.z + protrusion_z + protrusion_case,
        press_dimensions.y,
        press_dimensions.x,
    ];

    translate([-press_dimensions.x, -press_dimensions.y, -protrusion_case]) {
        difference() {
            // the pill box shaped part
            translate([0, 0, -protrusion_z])
                rotate([0,-90,0])
                    translate([0, 0, -press_dimensions_rotated.z])
                        box(press_dimensions_rotated, vertical_radius=protrusion_z, horizontal_radius=protrusion_x);

            // cut off the lower rounded edges
            translate([-1, -1, -press_dimensions.z])
                cube(press_dimensions + [2, 2, 0]);
        }

        // connector to the wall
        translate([protrusion_x, 0, 0])
            cube(press_dimensions + [0, 0, protrusion_case - protrusion_z]);

        // connector to the screw_pillar
        translate([0, protrusion_x, 0])
            cube(press_dimensions + [protrusion_x, 0, protrusion_case - protrusion_z]);
    }
}


wire_clutch();

translate([led_wire_clutch_width + case_wall, -led_wire_clutch_length, 0])
    clutch_clamp();
