/*

Mount for Power Bricks

    mount(
        brick_width,
        brick_height,
        spax=4,
        rim=true,
        leeway=1,
        thickness=5,
        rim_thickness=2,
        rim_height=3,
        screw_wall=4,
        chamfer=1,
        )

Parameters:

 - brick_width: the width of the power brick
 - brick_height: the height of the power brick
 - spax: size of the screw (spax sizes ;-)
 - rim: add a rim as a stopper for the power brick
 - leeway: additional room given to the power brick size
 - thickness: thickness of the mount walls and plates
 - rim_thickness: thickness of the rim
 - rim_height: height of the rim
 - screw_wall: wall around the screw hole
 - chamfer: a rounded corner radius

The width of the mount is determined by the screw size and the `screw_wall`
parameter.

*/

include <dw-library/spax/spax.scad>;
use <dw-library/chamfer/chamfer.scad>;

$fn=60;

DEFAULT_SCREW_WALL = 4;
DEFAULT_THICKNESS = 5;
DEFAULT_RIM_THICKNESS = 2;
DEFAULT_RIM_HEIGHT = 3;
DEFAULT_SPAX_SIZE = 4;
DEFAULT_LEEWAY = 1;
DEFAULT_CHAMFER = 1;

_JOIN = 0.1;


function mount_width(spax=DEFAULT_SPAX_SIZE, wall=DEFAULT_SCREW_WALL) =
    let(head_width = spax_max_head_diameter(spax))
    head_width + 2 * wall;



module mount_base(brick_width, brick_height, spax, leeway, thickness, screw_wall, chamfer) {
    width = mount_width(spax, screw_wall);
    echo("Mount width in mm:", width);
    height = thickness;
    length = brick_width + leeway + 2 * (thickness + width);

    difference() {
        chamfered_cube([length, width, height], chamfer, edges=[4:11]);
        translate([width / 2, width / 2, height + _JOIN]) rotate([0,180,0]) spax_bore_hole(spax, height + _JOIN * 2);
        translate([length - width / 2, width / 2, height + _JOIN]) rotate([0,180,0]) spax_bore_hole(spax, height + _JOIN * 2);
        if (brick_width >= 100) {
            translate([length / 2, width / 2, height + _JOIN]) rotate([0,180,0]) spax_bore_hole(spax, height + _JOIN * 2);
        }
    }

}

module mount_walls(brick_width, brick_height, spax, leeway, thickness, screw_wall, chamfer) {
    width = mount_width(spax, screw_wall);
    height = brick_height + leeway + 2 * thickness;
    length = thickness;

    translate([width, 0, 0]) chamfered_cube([length, width, height], chamfer, edges=[4:11]);
    translate([width + thickness + leeway + brick_width, 0, 0]) chamfered_cube([length, width, height], chamfer, edges=[4:11]);

    translate([width, chamfer, thickness - _JOIN]) rotate([90, 0, 180]) basic_chamfer(width - chamfer * 2, screw_wall);
    translate([width + leeway + 2 * thickness + brick_width, width - chamfer, thickness - _JOIN]) rotate([90, 0, 0]) basic_chamfer(width - chamfer * 2, screw_wall);
}


module mount_top(brick_width, brick_height, spax, leeway, thickness, screw_wall, chamfer) {
    width = mount_width(spax, screw_wall);
    height = thickness;
    length = brick_width + leeway + 2 * thickness;

    translate([width, 0, thickness + brick_height + leeway]) chamfered_cube([length, width, height], chamfer);
}


module mount_rim(brick_width, brick_height, spax, leeway, thickness, screw_wall, rim_thickness, rim_height) {
    outer_rim_length = brick_width + leeway + thickness;
    outer_rim_height = brick_height + leeway + thickness;
    inner_rim_length = brick_width - 2 * rim_height;
    inner_rim_height = brick_height - 2 * rim_height;

    translate_x = mount_width(spax, screw_wall) + thickness / 2;
    translate_z = thickness / 2;

    translate([translate_x, 0, translate_z]) {
        difference() {
            dx = outer_rim_length - inner_rim_length;
            dz = outer_rim_height - inner_rim_height;
            cube([outer_rim_length, rim_thickness, outer_rim_height]);
            translate([dx / 2, -_JOIN, dz / 2]) cube([inner_rim_length, rim_thickness + 2 * _JOIN, inner_rim_height]);
        }
    }
}

module mount(
    brick_width,
    brick_height,
    spax=DEFAULT_SPAX_SIZE,
    rim=true,
    leeway=DEFAULT_LEEWAY,
    thickness=DEFAULT_THICKNESS,
    rim_thickness=DEFAULT_RIM_THICKNESS,
    rim_height=DEFAULT_RIM_HEIGHT,
    screw_wall=DEFAULT_SCREW_WALL,
    chamfer=DEFAULT_CHAMFER,
    ) {

    mount_base(brick_width, brick_height, spax, leeway, thickness, screw_wall, chamfer);
    mount_walls(brick_width, brick_height, spax, leeway, thickness, screw_wall, chamfer);
    mount_top(brick_width, brick_height, spax, leeway, thickness, screw_wall, chamfer);
    if (rim==true) {
        mount_rim(brick_width, brick_height, spax, leeway, thickness, screw_wall, rim_thickness, rim_height);
    }
}


mount(52, 33, spax=3, rim=false);
