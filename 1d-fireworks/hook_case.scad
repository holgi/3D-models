include <dimensions.scad>;

use <led_strip.scad>;
use <screw.scad>;
use <wire_clutch.scad>;
use <case.scad>


case_cut_height = case_plate + led_strip_height;


module _hook(outer_dimensions=hook_case_outer, width=10, height=case_wall) {
    hook_outer_diameter = outer_dimensions.x;
    hook_hole_diameter  = outer_dimensions.x - 2 * width;
    difference() {
        cylinder(h = height, d=hook_outer_diameter);
        translate([0, 0, -1])
            cylinder(h=height + 2, d=hook_hole_diameter);
        translate([-hook_outer_diameter, -hook_outer_diameter, -1])
            cube([hook_outer_diameter, hook_outer_diameter, height + 2]);
    }
    middle = (hook_outer_diameter - width) / 2;
    translate([-middle, 0, 0])
        cylinder(h=height, d=width);

    translate([0, -middle, 0])
        cylinder(h=height, d=width);

    translate([-width / 2, -hook_outer_diameter / 2, 0])
        cube([width, width / 2, height]);
}


module hook(outer_dimensions=hook_case_outer, width=7.5, cut_offset=0, joiner=case_wall) {
    hook_outer_diameter = outer_dimensions.x;
    hook_hole_diameter  = outer_dimensions.x - 2 * width;

    middle = (hook_outer_diameter - width) / 2;

    cut_size = [hook_outer_diameter, hook_outer_diameter, hook_outer_diameter];

    difference() {
        translate([0, middle - cut_offset, 0])
            _hook(outer_dimensions,width, height=3);
        translate([0, -cut_size.y / 2 - joiner, 0])
            cube(cut_size, center=true);
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


module hook_case_lower() {

    // the base case section
    difference() {
        case_section_lower(hook_case_outer, case_cut_height);

        // cutout for the led strip
        translate([-led_strip_width / 2, -1, 0])
            cube([led_strip_width, led_strip_clutch_length + 2, case_cut_height]);

        // giving the clucth a little slack
        translate([0, 0, -0.2])
            strip_clutch(slack=0.1);
    }

    // attach the hook
    translate([0, hook_case_outer.y, - case_plate]) hook();

    // the wire clutch clamps
    inner_clutch_edge = hook_case_inner.x / 2 - 1;
    outer_clutch_edge = led_wire_clutch_width / 2 + case_wall;
    center_offset     = inner_clutch_edge + (outer_clutch_edge - inner_clutch_edge) / 2;

    translate([-center_offset, wire_clutch_assembly_offset, 0])
        clutch_clamp();
    translate([+center_offset, wire_clutch_assembly_offset, 0])
        clutch_clamp();
}


module hook_case_upper() {
    // the base case section
    case_section_upper(hook_case_outer, case_cut_height);

    // the led strip clutch press
    difference() {
        translate([0, 0, hook_case_inner.z])
            rotate([0, 180, 0])
                strip_clutch(slack=0);
        // we need to shave off a little bitmore of the clutch height to close the case
        translate([-hook_case_inner.x / 2, -1, hook_case_inner.z - led_strip_clutch_height - 0.5])
            cube([hook_case_inner.x, led_strip_clutch_length +  2, 1]);
    }

    press_x_offset = hook_case_outer.x / 2 - case_wall;
    press_y_offset = hook_case_outer.y - screw_pillar_diameter;

    for(i=[0, 1]) {
        mirror([i, 0, 0])
            translate([press_x_offset, press_y_offset, 0])
                wire_clutch_press(hook_case_outer, case_cut_height);
    }
}

// Assembly

color("LightBlue", 0.5)
    led_strip();

color("Orange", 0.5)
    translate([0, wire_clutch_assembly_offset + led_wire_clutch_length / 2 + 2, 0])
        wire_clutch();

hook_case_lower();

translate([50, 0, 0]) hook_case_upper();


translate([- 50, 0, 0]) case(hook_case_outer);
