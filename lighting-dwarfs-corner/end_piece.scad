include <constants.scad>

use <helpers.scad>
use <beam_holder.scad>


rad_offset = 200;

module end_piece_projection() {
    loop_offset = LOOP_ATTACHMENT_HEIGHT + LOOP_WALL_HEIGHT + JOINT_SAFETY;
    // the inner diameter must be reduced to get stronger walls
    inner_diameter = BEAM_DIAMETER - 2;
    projection(cut = false) {
        rotate([0,0,-90]) { // rotate, center on y=0
            rotate([90,0,0]) {  // rotate flat on x-plane
                translate([0, 0, -loop_offset]) {
                    wood_beam_loop(height=LOOP_WALL_HEIGHT, diameter=inner_diameter, i=0, r=2);
                }
            }
        }
    }
}

module end_piece_extrude() {
    rotate_extrude(convexity = 10, angle=-LIVING_ROOM_ANGLE) {
        translate([rad_offset, 0, 0]) end_piece_projection();
    }
}

module end_piece_positioning() {
    rotate([0,90,0]) {
        translate([-rad_offset, 0, 0]) {
            end_piece_extrude();
        }
    }
}

module end_piece() {
    translate([0, -JOINT_SAFETY, -LOOP_ATTACHMENT_HEIGHT]) {
        wood_beam_holder();
    }
    translate([0, -85, -LOOP_ATTACHMENT_HEIGHT]) {
        // the wood beem loop has an inset of 0 instead of 1
        // this leads to thinner walls, the braket must be extended
        off = 3.2;
        wood_beam_holder_joint(SCREW_BLOCK_WIDTH, BEAM_DIAMETER + off, BRACKET_WALL);
    }
    difference()  {
        end_piece_positioning();
        translate([10, -103, -LOOP_ATTACHMENT_HEIGHT - JOINT_SAFETY]) {
             union(){
                cube([10, 120, 10]);
                rotate([65, 0, 0]) cube([10, 10, 10]);
            }
        }
        translate([-20, -103, -LOOP_ATTACHMENT_HEIGHT - JOINT_SAFETY]) {
            union(){
                cube([10, 120, 10]);
                rotate([65, 0, 0]) cube([10, 10, 10]);
            }
        }
        translate([0, -250, 67]) roof(length=400, width=50);
    }
}




end_piece();

//end_piece_projection();
