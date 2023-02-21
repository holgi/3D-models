/*
    Cubes with rounded corners


    module rounded_cube(
        dimensions,     // outer dimensions of cube as vector
        corner_radius,  // corner radius of the sides
        top_radius,     // radius of the top corners, defaults to corner_radius
        bottom_radius,  // radius of the bottom corners, defaults to corner_radius
        center=false,   // position centered
    )

*/

module rounded_cube(
    dimensions,          // outer dimensions of cube as vector
    corner_radius,       // corner radius of the sides
    top_radius = -1,     // radius of the top corners, defaults to corner_radius
    bottom_radius = -1,  // radius of the bottom corners, defaults to corner_radius
    center=false,        // position centered
) {

    $fn=60;

    top_r = top_radius < 0 ? corner_radius : top_radius;
    bottom_r = bottom_radius < 0 ? corner_radius : bottom_radius;

    delta_x = (dimensions.x / 2) - corner_radius;
    delta_y = (dimensions.y / 2) - corner_radius;
    delta_z_top = (dimensions.z / 2) - top_r;
    delta_z_bottom = (dimensions.z / 2) - bottom_r;

    module _bend_corner(radius, bend) {
        cut_size = radius + 1;
        rotate_extrude(angle = 90)
            translate([bend, 0, 0])
            difference() {
                circle(r=radius);
                translate([-cut_size, 0, 0])
                    square(cut_size * 2, center=true);
            }

    }

    module _real_corners(z, radius) {
        translate([delta_x, delta_y, z]) {
            if (radius == 0) {
                tmp_z = z < 0 ? 0 : -1;
                translate([0, 0, tmp_z]) cylinder(1, r=corner_radius);
            } else {
                bend_radius = corner_radius - radius;
                _bend_corner(radius, bend_radius);
            }
        }
    }

    module _fake_corners(z, radius) {
        dx = (dimensions.x / 2 ) - radius;
        dy = (dimensions.y / 2 ) - radius;
        if (radius == 0) {
            tmp_z = z < 0 ? z + 0.5 : z - 0.5;
            translate([dx - 0.5, 0, tmp_z])
                cube([1, 1, 1], center=true);
            translate([0, dy - 0.5, tmp_z])
                cube([1, 1, 1], center=true);
        } else {
            translate([dx, 0, z])
                rotate([90, 0, 0])
                cylinder(1, r=radius, center=true);
            translate([0, dy, z])
                rotate([0, 90, 0])
                cylinder(1, r=radius, center=true);
        }

    }

    module _quarter() {
        hull() {
            _real_corners(+delta_z_top, top_r);
            _real_corners(-delta_z_bottom, bottom_r);

            _fake_corners(+delta_z_top, top_r);
            _fake_corners(-delta_z_bottom, bottom_r);
            cube([1, 1, dimensions.z], center=true);
        }
    }

    module _half() {
        mirror([0, 0, 0]) _quarter();
        mirror([1, 0, 0]) _quarter();
    }

    translate_to = center ? [0, 0, 0] : dimensions / 2;

    translate(translate_to) {
        mirror([0, 0, 0]) _half();
        mirror([0, 1, 0]) _half();
    }
}


rounded_cube(
    dimensions=[40, 30, 20],
    corner_radius=5,
    top_radius=2,
    bottom_radius=0,
    center=true
);
//#cube([40, 30, 20], center=true);

