/*

A case for screwing stuff to a wall

    wall_mount(
        box,
        slack=1,
        wall=3.2,
        screw=3,
        ears=true
        )


Parameters:

 - box: the size of the box you want to be mounted on the wall
 - slack: how much slack there should be between the box and the case
 - wall: thickness of the walls and base plate
 - screw: diameter of the screws you want to use
 - ears: if true, the screws are on the outside of the case

*/


slack =  1;     // mm
wall  =  3.2;   // mm
screw =  3;     // mm

$fn   = 60;     // facets per 360°
JOIN  =  0.01;  // mm


function add_scalar(v, c) = v + [c, c, c];


module four_corners(dx, dy, z_offset=0) {
    translate([-dx, -dy, z_offset])
        children();
    translate([+dx, -dy, z_offset])
        rotate([0, 0, 180]) children();
    translate([-dx, +dy, z_offset])
        children();
    translate([+dx, +dy, z_offset])
        rotate([0, 0, 180]) children();
}


module rounded_rect(outer_size, radius=wall) {
    diameter = 2 * radius;
    radius_adjusted = outer_size - [diameter, diameter, 0];
    corner_center_x = radius_adjusted[0] / 2;
    corner_center_y = radius_adjusted[1] / 2;
    z = outer_size[2];
    hull()
        four_corners(corner_center_x, corner_center_y, 0)
            cylinder(z, d=diameter, center=true);
}

module cutout(box, slack=slack, wall=wall) {
    slack_cutout = add_scalar(box, slack);
    inner_cutout = add_scalar(box, -wall * 2);

    y = slack_cutout[1] + 2 * wall;
    translate([0, wall, 0])
        cube([slack_cutout[0], y, slack_cutout[2]], center=true);

    translate([0, wall * 2, wall * 3 + JOIN])
        cube([inner_cutout[0], y, inner_cutout[2]], center=true);

}


module wall_mount(box, slack=slack, wall=wall, screw=screw, ears=true) {
    outer_size = add_scalar(box, slack + wall * 2);

    difference()  {
        union() {
            rounded_rect(outer_size, radius=wall);
            if (ears) {
                screw_ears(outer_size, screw=screw, wall=wall);
            }
        }
        cutout(box, slack=slack, wall=wall);
        if (!ears) {
            dx = outer_size[0] / 2 - screw / 2 - wall * 2 - slack;
            dy = outer_size[1] / 2 - screw / 2 - wall * 2 - slack;
            dz = outer_size[2] / 2 - wall / 2;
            four_corners(dx, dy, -dz) screw_head(screw, wall);
        }
    }
}


module screw_head(screw, wall) {
    radius = screw / 2;
    cylinder(wall * 2, radius, radius, center=true);
    cylinder(wall, radius, wall + radius);
}


module screw_ears(outer_size, screw=screw, wall=wall) {
    outer_diameter = screw + 2 * wall;

    dx = outer_size[0] / 2;
    dy = outer_size[1] / 2 - screw / 2 - wall;
    dz = outer_size[2] / 2 - wall / 2;


    four_corners(dx, dy, -dz) {
        translate([-outer_diameter / 2, 0, 0]) {
            difference() {
                union() {
                    cylinder(wall, d=outer_diameter, center=true);
                    translate([outer_diameter/2,  0, 0])
                        cube([outer_diameter, outer_diameter, wall], center=true);
                }
                screw_head(screw, wall);
            }
        }
    }
}



wall_mount([70, 70, 22], ears=true);

