include <constants.scad>

use <helpers.scad>
use <angled_plates.scad>
use <beam_holder.scad>

module round_part() {
    difference() {
        translate([-21, -25, -21]) cube([20, 50, 20]);
        translate([0, -50, 0]) rotate([0,45,0]) wood_beam();
        translate([-37, -26, -21]) rotate([0,45,0]) cube([22, 52, 22]);
    }
}

module edge_part() {
    difference() {
        translate([-14, -25, -14]) cube([22, 50, 22]);
        translate([0, -50, 0]) rotate([0,45,0]) wood_beam();
        translate([-6, -26, 11]) rotate([0,45,0]) cube([24, 52, 22]);
        translate([-15, -26, -15]) cube([8, 52, 8]);
    }
}

round_part();
edge_part();

translate([10, 0, 10]) edge_part();
translate([20, 0, 20]) edge_part();
