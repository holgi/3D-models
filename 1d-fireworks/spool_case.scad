
include <dimensions.scad>;

use <qtpy.scad>;
use <led_strip.scad>;
use <wire_clutch.scad>;
use <WAGO_221_mount.scad>;



module spool_2d(delta=0, corner=spool_case_corner, taper=spool_case_taper, height=spool_case_height, diameter=spool_case_diameter) {
    half_height = height / 2;
    radius = spool_case_diameter / 2;

    polygon = [
        [-delta,          -half_height],
        [radius - corner, -half_height],
        [radius - corner, -half_height + corner],
        [radius,          -half_height + corner],
        [radius + taper,   0],
        [radius,          +half_height - corner],
        [radius - corner, +half_height - corner],
        [radius - corner, +half_height],
        [-delta,          +half_height]
    ];

    offset(r=-delta) {
        polygon(polygon);
        translate([radius - corner, -half_height + corner, 0])
            circle(r=corner);
        translate([radius - corner, +half_height - corner, 0])
            circle(r=corner);
    }
}


module spool_3d(delta=0) {
    rotate([0, 90, 0])
        rotate_extrude()
            spool_2d(delta=delta);
}


module spool_case(wall=case_wall, inset=0) {
    difference() {
        spool_3d(delta=inset);
        spool_3d(delta=inset + wall);
    }
}


module spool_cut(height, direction=1) {
    cut_at = height + spool_cutter.z / 2;
    difference() {
        children();
        translate([0, 0, cut_at * direction])
            cube(spool_cutter, center=true);
    }
}


module spool_led_protection_bulge_2d() {

    angle = atan(spool_protection_bulge / spool_case_diameter);
    bulge_center_offset = spool_protection_bulge * (1 - cos(angle));

    ellipses_length = spool_case_diameter + spool_protection_bulge + bulge_center_offset * 2;
    ellipses_width  = spool_case_diameter;
    ellipses_cut    = [ellipses_length + 2, ellipses_width + 2];


    translate([spool_case_diameter / 2, spool_protection_bulge / 2, 0])
        circle(d=spool_protection_bulge );
    difference() {
        translate([0, 0, 0])
            circle(d=spool_case_diameter);
            translate([-ellipses_cut.x / 2 - 1, -ellipses_cut.y, 0])
                square(ellipses_cut);
    }

    rotate([0, 0, angle]) {
        difference() {
            resize([ellipses_length, ellipses_width])
                circle(d=20);
            translate([-ellipses_cut.x / 2 - 1, -ellipses_cut.y, 0])
                square(ellipses_cut);
            translate([-ellipses_cut.x, -ellipses_cut.y / 2, 0])
                square(ellipses_cut);
        }
    }
}


module spool_led_protection_bulge_3d(height=spool_case_strip_height, wall=5) {
    translate([-height / 2, 0, 0])
        rotate([-90, 0, -90])
            difference() {
                linear_extrude(height)
                    spool_led_protection_bulge_2d();
                translate([0,0,-1])
                    linear_extrude(height + 2)
                        offset(-wall)
                            spool_led_protection_bulge_2d();
            }
}


module spool_case_lower_base(cut=spool_case_cut, rim=spool_case_rim_height, slack=spool_case_rim_slack) {
    spool_cut(-cut)
        spool_3d();

    spool_cut(cut - slack - rim / 2)
        spool_case();

    spool_cut(cut + rim / 2)
        spool_case(wall=case_wall / 2 - slack);

    difference() {
        spool_led_protection_bulge_3d(spool_case_strip_height - 5);
        cube([spool_case_strip_height + 1, spool_case_diameter, cut * 2], center=true);
    }
}


module spool_case_upper_base(cut=spool_case_cut, rim=spool_case_rim_height, slack=spool_case_rim_slack) {
    spool_cut(-cut + rim / 2, direction=-1)
        spool_case(wall=case_wall/2, inset=1 + slack);

    spool_cut(-cut - rim / 2, direction=-1)
        spool_case(wall=case_wall / 2);
}


module spool_wago_mount(position=30) {
    width = wago_mount_width([2, 5]);

    translate([-spool_case_height/2 + case_wall, 0, -position])
        rotate([0, 0, 90])
            mirror([0, 1, 0])
                translate([-width / 2, 0, (20.25 - 2)])
                    rotate([-90, 0, 0])
                        wago_mount([2, 5]);

    difference() {
        spool_cut(-position) spool_3d();
        translate([+spool_case_height/2 - 13.85, 0, 0])
            cube([spool_case_height, spool_case_diameter + 2, spool_case_diameter + 2], center=true);
    }
}


module spool_qtpy_mount(distance=35) {
    spool_cut(-distance)
        spool_3d();
    translate([0 , 0, -distance])
        qtpy_mount();
}


module spool_case_lower() {

    // the base case section
    difference() {
        translate([0, spool_case_radius, 0])
            spool_case_lower_base();

        // cutout for the led strip
        translate([-led_strip_width / 2, -led_strip_clutch_length * 2, -led_strip_height / 2])
            cube([led_strip_width, led_strip_clutch_length * 4, led_strip_height]);

        // giving the clucth a little slack
        translate([0, 0, -led_strip_height / 2 + 0.2])
            strip_clutch(slack=2);

    }

    // the wire clutch clamps
    inner_clutch_edge = hook_case_inner.x / 2 - 1;
    outer_clutch_edge = led_wire_clutch_width / 2 + case_wall;
    center_offset     = inner_clutch_edge + (outer_clutch_edge - inner_clutch_edge) / 2;

    translate([-center_offset, wire_clutch_assembly_offset, - led_strip_height / 2])
        clutch_clamp();
    translate([+center_offset, wire_clutch_assembly_offset,  -led_strip_height / 2])
        clutch_clamp();

}


module spool_case_upper() {
    usb_c_cutout = usb_c_connector + [0, 2, 0];

        difference() {
            rotate([180,0,0])
                spool_case_upper_base();

            rotate([170, 0, 0])
                translate([-usb_c_cutout.x / 2, -spool_case_radius - 1, 0])
                cube(usb_c_cutout);
    }


    // translate([0, -spool_case_radius, led_strip_height + spool_case_cut])
    translate([0,  -spool_case_radius, led_strip_height - spool_case_cut])
            rotate([0, 180, 0])
                strip_clutch(slack=0);

    difference() {
            spool_cut(-spool_case_cut - spool_case_rim_height / 2, direction=1)
                spool_3d(delta=1 + spool_case_rim_slack);
            translate([0, led_strip_clutch_length + case_wall / 2, 0])
                cube(spool_cutter, center=true);
        }


    spool_wago_mount(25);
    mirror([1,0,0]) spool_wago_mount(25);

    spool_qtpy_mount();

}



translate([140,0,0]) spool_case_lower();

translate([0,0,0]) spool_case_upper();

