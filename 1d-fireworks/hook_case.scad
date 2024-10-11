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


module hook(outer_dimensions=hook_case_outer, width=10, cut_offset=0, joiner=case_wall) {
    hook_outer_diameter = outer_dimensions.x;
    hook_hole_diameter  = outer_dimensions.x - 2 * width;

    middle = (hook_outer_diameter - width) / 2;

    cut_size = [hook_outer_diameter, hook_outer_diameter, hook_outer_diameter];

    difference() {
        translate([0, middle - cut_offset, 0])
            _hook();
        translate([0, -cut_size.y / 2 - joiner, 0])
            cube(cut_size, center=true);
    }
}


module strip_clutch(slack=0) {
    strip_clutch_pressing = led_strip_height - led_strip_clutch_height;

    /*
    translate([-led_strip_width / 2, -slack / 2, led_strip_clutch_height])
        cube([led_strip_width, led_strip_clutch_length + slack, strip_clutch_pressing]);
    */
    translate([(led_strip_width + case_wall) / 2, -slack/2, led_strip_clutch_height])
        rotate([-90, 180, 0])
            linear_extrude(led_strip_clutch_length + slack)
                polygon([
                    [0, strip_clutch_pressing + 1],
                    [case_wall / 2, 0],
                    [led_strip_width + case_wall / 2, 0],
                    [led_strip_width + case_wall, strip_clutch_pressing + 1]
                ]);
}


module hook_case_lower() {

    // the base case section
    difference() {
        case_section_lower(hook_case_outer, case_cut_height);

        // cutout for the led strip
        translate([-led_strip_width / 2, -1, 0])
            cube([led_strip_width, led_strip_clutch_length + 2, case_cut_height]);

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
    translate([0, 0, hook_case_inner.z ])
        rotate([0, 180, 0])
            strip_clutch(slack=0);

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

