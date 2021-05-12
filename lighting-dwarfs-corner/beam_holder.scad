include <constants.scad>

use <helpers.scad>

module wood_beam(length=100, diameter=BEAM_DIAMETER, cut_height=6) {
    radius = diameter / 2;
    cut_width = diameter + 2;
    translate([0, 0, cut_height]) {
        difference() {
            rotate([0,-45,0]) {
                difference() {
                    rotate([-90,0,0]) {
                        cylinder(length, radius, radius);
                    }
                    translate([-cut_width / 2, -1, 0]) {
                        cube([cut_width, length + 2, cut_width]);
                    }
                    translate([0, -1, -cut_width / 2]) {
                        cube([cut_width, length + 2, cut_width]);
                    }
                }
            }
            translate([-cut_width / 2, -1, -cut_height]) {
                cube([cut_width, length + 2, cut_width]);
            }
        }
    }
}


module screw_block_joint(width=SCREW_BLOCK_WIDTH, bracket=BRACKET_WALL, outline=0) {
    translate([-8 - outline, 0, bracket - outline]) {
        soft_corner_bracket(bracket + 1 + outline, width, bracket + 2 * outline);
    }
    translate([8 + outline, 0, bracket - outline]) {
        mirror([1, 0, 0]) {
            soft_corner_bracket(bracket + 1 + outline, width, bracket + 2 * outline);
        }
    }
    translate([-5 - outline, 0, -1]) {
        cube([10 + 2 * outline, width, 2 * bracket + 1 + outline]);
    }

        translate([-5 - outline, 0, bracket - outline]) {
            fillet(width, 1);
        }
        translate([5 + outline, 0, bracket - outline]) {
            mirror([1, 0, 0]) fillet(width, 1);
        }

}


module wood_beam_with_block(length=10, diameter=BEAM_DIAMETER, cut_height=6, b_height=25, inset=0) {
    join_to = (cos(45) *  diameter / 2) - cut_height;
    b_width = (sin(45) *  diameter) - (inset*2);
    if (diameter != BEAM_DIAMETER) { echo(b_width); }
    wood_beam(length, diameter);
    translate([-b_width/2, 0, -join_to]) cube([b_width, length, b_height + join_to]);
}

module wood_beam_loop(length=SCREW_BLOCK_WIDTH, height=25, diameter=BEAM_DIAMETER, r=BEAM_LOOP_DELTA, i=1) {
    outer_diameter = diameter + 2 * r;
    difference() {
        wood_beam_with_block(length, outer_diameter, b_height=height);
        translate([0, -1, 0]) {
            wood_beam_with_block(length+2, diameter, b_height=height+1, inset=i);
            hull() {
                wood_beam(length+2, diameter);
                translate([0, 0, JOINT_SAFETY]) {
                    wood_beam(length+2, diameter);
                }
            }
        }
    }
}

module wood_beam_holder_joint(length=SCREW_BLOCK_WIDTH, diameter=BEAM_DIAMETER, bracket=BRACKET_WALL, i=1) {
    width = (sin(45) *  diameter - 2 * i);
    translate([0, 0, 0]) {
        screw_block_joint(length, bracket);
    }
    translate([-width/2, 0, -bracket - JOINT_SAFETY]) {
        cube([width, length, bracket]);
    }

    translate([width/2, 0, -bracket - JOINT_SAFETY]) {
        fillet(length);
    }
    translate([-width/2, 0, -bracket - JOINT_SAFETY]) {
        mirror([1,0,0]) fillet(length);
    }
}

module wood_beam_holder(length=SCREW_BLOCK_WIDTH, height=LOOP_WALL_HEIGHT, diameter=BEAM_DIAMETER, r=BEAM_LOOP_DELTA, i=1, bracket=BRACKET_WALL) {
    inner_width = (sin(45) *  diameter - 2 * i);
    outer_width = (sin(45) *  (diameter + 2 * r));
    translate([0, 0, -height - JOINT_SAFETY]) {
        wood_beam_loop(length, height, diameter, r, i);
    }
    wood_beam_holder_joint(length, diameter, bracket);
}

module senkkopf(outer_diameter=10, inner_diameter=4, height=20) {
    outer_radius = outer_diameter / 2;
    inner_radius = inner_diameter / 2;
    radius_diff = outer_radius - inner_radius;
    cylinder(radius_diff, outer_radius, inner_radius);
    cylinder(height, inner_radius, inner_radius);
}

module screw_block_base(width=SCREW_BLOCK_WIDTH) {
    difference() {
        translate([-LOOP_ATTACHMENT_WIDTH / 2, 0, 0]) {
            cube([LOOP_ATTACHMENT_WIDTH, width, LOOP_ATTACHMENT_HEIGHT]);
        }
        // roof
        translate([0, -1, LOOP_ATTACHMENT_HEIGHT]) {
            rotate([0, 90 - DWARF_ANGLE / 2, 0]) {
                cube([LOOP_ATTACHMENT_WIDTH, width + 2, LOOP_ATTACHMENT_HEIGHT]);
            }
        }
        translate([-LOOP_ATTACHMENT_WIDTH /2, -1, 0]) {
            rotate([0, 270 + DWARF_ANGLE / 2, 0]) {
                cube([LOOP_ATTACHMENT_WIDTH, width + 2, LOOP_ATTACHMENT_HEIGHT]);
            }
        }
        translate([0, -50, LOOP_ATTACHMENT_HEIGHT]) {
            roof();
        }
        // joint for lower thingy
        translate([0, -1, 0]) {
            screw_block_joint(SCREW_BLOCK_WIDTH+2, BRACKET_WALL, outline=JOINT_SAFETY);
        }
        // screw hole
        translate([0, width/2, 2 * BRACKET_WALL-0.5]){
            senkkopf();
        }
    }
}

screw_block_base();