include <constants.scad>

use <angled_plates.scad>

module fillet(length=10, radius=5) {
    join_safety = 0.5;
    translate([-radius, 0, -radius]) {
        difference() {
            cube([radius + join_safety, length, radius  + join_safety]);
            translate([0, -1, 0]) {
                rotate([-90, 0, 0]) {
                    cylinder(length + 2, radius, radius);
                }
            }
        }
    }
}


module soft_corner_bracket(length=5, width=5, height=3) {
    radius = height / 4;
    translate([radius, 0, 0 ]) cube([length-radius, width, height]);
    translate([0, 0, radius ]) cube([length, width, height-radius*2]);
    translate([radius, 0, radius]) rotate([-90, 0, 0])cylinder(width, radius, radius);
    translate([radius, 0, height-radius]) rotate([-90, 0, 0])cylinder(width, radius, radius);
}

module living_room_roof(angle=LIVING_ROOM_ANGLE, length=100) {
    rotate([90-angle,0,0]) {
        translate([-length*2, -length, -length*2]) {
            cube([length*4, length , length*4]);
        }
    }
}

module roof(angle=DWARF_ANGLE, diameter=5, lr_angle=LIVING_ROOM_ANGLE, length=100, width=5) {
    half_angle = angle/2;
    z_offset = join_width(5, angle);
    translate([0, 0, z_offset]) {
        difference() {
            rotate([0 ,half_angle+90, 0]) {
                angled_plates(length, 100, width, angle, diameter*2, diameter);
            }
            living_room_roof(lr_angle, length);
        }
    }
}
