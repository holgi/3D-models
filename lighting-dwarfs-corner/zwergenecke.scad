include <constants.scad>

use <helpers.scad>
use <angled_plates.scad>
use <beam_holder.scad>
use <electronics.scad>
use <end_piece.scad>




module all() {
    roof(length=200);
    translate([0,0, -LOOP_ATTACHMENT_HEIGHT]) {
        #translate([0, -SCREW_BLOCK_WIDTH -1, -LOOP_WALL_HEIGHT-JOINT_SAFETY-.5]) wood_beam(diameter=42);
        //translate([0, 0, -LOOP_WALL_HEIGHT]) wood_beam_loop();
        %translate([0,0, 2 * BRACKET_WALL]) senkkopf();
        screw_block_base();

        translate([0, -SCREW_BLOCK_WIDTH, 0]) wood_beam_holder();
        //all_electronics();
        translate([0, -SCREW_BLOCK_WIDTH, LOOP_ATTACHMENT_HEIGHT]) end_piece();
    }
}

all();
