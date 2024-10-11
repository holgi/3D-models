include<dimensions.scad>;
include<box.scad>;



module wire_clutch() {

    full_height = wire_clutch_height + wall_width;
    base_width = hook_box_inner_width - 1;  // 1 mm slack
    thick_width = wire_clutch_width + 2 * wall_width;

    base_vector = [base_width, wire_clutch_length, led_strip_clutch_height];
    thick_vector = [thick_width, wire_clutch_length, full_height];

    difference() {
        union() {
            // base
            box(base_vector, radius=2, z_radius=0);
            // thicker part
            translate([0, 0, full_height / 2])
                cube(thick_vector, center=true);
        }

        // nice round upper edge 1
        translate([thick_vector.x / 2 - 1, 0, full_height - 1])
            rotate([90, 0, 0])
                rounded_edge(20, radius=2 );

        // nice round upper edge 2
        translate([-thick_vector.x / 2 + 1, 0, full_height - 1])
            rotate([-90, 180, 0])
                rounded_edge(20, radius=2 );

        // channel for the wires
        translate([0, 0, wire_clutch_height / 2 - 1])
            cube([wire_clutch_width, wire_clutch_length + 2, wire_clutch_height + 2], center=true);

        // nice round channel edge 1
        translate([-wire_clutch_width / 2 - wire_clutch_height / 2, 0, wire_clutch_height / 2])
            rotate([-90, 0, 0])
                rounded_edge(20, radius=wire_clutch_height );

        // nice round channel edge 2
        translate([wire_clutch_width / 2 + wire_clutch_height / 2, 0, wire_clutch_height / 2])
            rotate([90, 180, 0])
                rounded_edge(20, radius=wire_clutch_height );

    }

}

module clutch_clamp() {

    slide_length = wire_clutch_clamp_width;
    block_length = wire_clutch_clamp_width * 2;
    height = led_strip_clutch_height + wall_width;

    nice_radius = led_strip_clutch_height;
    half_nice_radius = nice_radius / 2;

    difference() {
        // full block to start with
        translate([ -wire_clutch_clamp_width / 2, -block_length / 2, -1])
            cube([wire_clutch_clamp_width, block_length, height + 1]);

        // make a slight slide edge
        translate([0, 0, led_strip_clutch_height])
            for(angle=[0,7]) {
                rotate([angle, 0, 0])
                    translate([-wire_clutch_clamp_width / 2 - 1, 0, -height])
                        cube([wire_clutch_clamp_width + 2, slide_length + 1, height]);
            }

        // some nice round edges, part 1
        translate([0, -slide_length + half_nice_radius, height - half_nice_radius])
            rotate([90, -90, 90])
                rounded_edge(wire_clutch_clamp_width + 2, radius=nice_radius);

        // some nice round edges, part 2
        // custom aligned for the sloped edge
        translate([0, slide_length-half_nice_radius, 2.65])
            rotate([90, 90, 90])
                rounded_edge(wire_clutch_clamp_width + 2, radius=nice_radius);
    }
}
