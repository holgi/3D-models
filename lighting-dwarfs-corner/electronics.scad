include <constants.scad>

use <helpers.scad>
use <beam_holder.scad>


inch = 25.4;
small_inch = 25;
wall_thickness = 2;

increased_loop_width = sin(45) *  (BEAM_LOOP_DIAMETER + wall_thickness);


module cable_slot() {
    difference() {
        cube([30, 20 + JOINT_SAFETY, ELECTRONIC_BASE_HEIGHT]);
        translate([10, 7.5, -1]) cube([10, 5, ELECTRONIC_BASE_HEIGHT + 2]);
    }
}

module electronic_buck() {
    cube([30, 40 + JOINT_SAFETY, ELECTRONIC_BASE_HEIGHT]);
    }

module _electronic_lift() {
    radius_plug = 0.09 * small_inch / 2;
    radius_lift = 0.1 * small_inch;
    cylinder(ELECTRONIC_BASE_HEIGHT + 4, radius_lift, radius_lift);
    cylinder(ELECTRONIC_BASE_HEIGHT + 4 + 1, radius_plug, radius_plug);
}

module electronic_feather() {
    plug_x_dist = 0.75 * inch;
    plug_x_offset = (30 - plug_x_dist) / 2;
    plug_y_dist = 1.8 * inch;
    difference() {
        union() {
            cube([30, 70 + JOINT_SAFETY, ELECTRONIC_BASE_HEIGHT]);
            translate([plug_x_offset, 18, 0]) {
                translate([0, 0, 0]) _electronic_lift();
                translate([plug_x_dist, 0, 0]) _electronic_lift();
                translate([0, plug_y_dist, 0]) _electronic_lift();
                translate([plug_x_dist, plug_y_dist, 0]) _electronic_lift();
            }
        }
    }
}

module electronic_driver() {
    plug_x_offset = 5;
    plug_x_dist = 16;
    plug_y_dist = 36;
    difference() {
        union() {
            cube([30, 60, ELECTRONIC_BASE_HEIGHT]);
            translate([plug_x_offset, 12, 0]) {
                translate([0, 0, 0]) _electronic_lift();
                translate([plug_x_dist, 0, 0]) _electronic_lift();
                translate([0, plug_y_dist, 0]) _electronic_lift();
                translate([plug_x_dist, plug_y_dist, 0]) _electronic_lift();
            }
        }

    }
}

module electronics_plate() {
    translate([0, 0, 0]) cable_slot();
    translate([0, 20, 0]) electronic_buck();
    translate([0, 20 + 40, 0]) electronic_feather();
    translate([0, 20 + 40 + 70, 0]) cable_slot();
    translate([0, 20 + 40 + 70 + 20, 0]) electronic_driver();
}


module _electronics_case() {
    wall_height = 28;

    // main case
    translate([0, 0, -wall_height - JOINT_SAFETY]) {
        wood_beam_loop(210, height=wall_height, diameter=ELECTRONIC_DIAMETER, i=0, r=wall_thickness);
    }

    // electronic rails
    translate([-LOOP_ATTACHMENT_WIDTH/2, 0, -wall_height - 10]) cube([5, 210, 2]);
    translate([LOOP_ATTACHMENT_WIDTH/2 - 5, 0, -wall_height - 10]) cube([5, 210, 2]);

    // joints
    translate([0, JOINT_SAFETY - SCREW_BLOCK_WIDTH, 0]) {
        wood_beam_holder(r=wall_thickness);
    }
    translate([0, (210 - SCREW_BLOCK_WIDTH) / 2, 0]) {
        wood_beam_holder_joint(diameter=ELECTRONIC_DIAMETER, i=0);
    }
    translate([0, 210 - SCREW_BLOCK_WIDTH, 0]) {
        wood_beam_holder_joint(diameter=ELECTRONIC_DIAMETER, i=0);
    }

    // lower front plate
    translate([0, JOINT_SAFETY - 1, -wall_height - JOINT_SAFETY]) {
        hull() {
            wood_beam_loop(length=1, height=0, diameter=ELECTRONIC_DIAMETER, r=wall_thickness);
            translate([- increased_loop_width/2, -1, -10]) cube([increased_loop_width, 2, 16]);
        }

    }

}

module electronics_case() {
    difference() {
        _electronics_case();

        // cable breakout
        translate([0, 210, -5 - BRACKET_WALL - JOINT_SAFETY]) {
            difference() {
                rotate([0,90,0]) cylinder(30, 5, 5);
                translate([-10, 0, -10]) cube(20);
            }
        }
    }
}
module all_electronics() {
    #translate([-15, 0, -36]) electronics_plate();
    electronics_case();
}

electronics_case();
