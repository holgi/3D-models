use <../_library/rounded_cube/rounded_cube.scad>;

include <dimensions.scad>;
use <screw.scad>


module box(dimensions, vertical_radius=screw_pillar_radius, horizontal_radius=case_z_radius, center=false) {

    rounded_cube(
        dimensions=dimensions,
        corner_radius=vertical_radius,
        top_radius=horizontal_radius,
        bottom_radius=horizontal_radius,
        center=center
    );
}


module base_case(outer_dimensions, wall=case_wall, plate=case_plate) {
    inner_dimensions = outer_dimensions - 2 * [wall, wall, plate];
    inner_vertical_radius = screw_pillar_radius - case_wall;
    pillar_height = outer_dimensions.z - 2 * case_z_radius;

    difference() {
        box(outer_dimensions, center=true);
        box(inner_dimensions, vertical_radius=inner_vertical_radius, center=true);
    }

}


module four_corners(dimensions) {
    x_offset = dimensions.x / 2;
    y_offset = dimensions.y / 2;

    for (x=[-x_offset, +x_offset]) {
        for (y=[-y_offset, +y_offset]) {
            translate([x, y, 0])
                children();
        }
    }
}

module case(outer_dimensions) {
    pillar_dimensions = outer_dimensions - 2 * [screw_pillar_radius, screw_pillar_radius, case_z_radius];
    clutch_width = outer_dimensions.x - 2 * (screw_pillar_diameter - case_wall);

    difference() {
        union() {
            base_case(outer_dimensions);
            four_corners(pillar_dimensions)
                cylinder(pillar_dimensions.z, r=screw_pillar_radius, center=true);

        }
        four_corners(pillar_dimensions)
            screw_and_nut_hole(outer_dimensions.z, center=true);
    }
    // led strip clutch area
    translate([0, -(outer_dimensions.y - led_strip_clutch_length) / 2, 0])
        cube([clutch_width, led_strip_clutch_length, pillar_dimensions.z], center=true);
}



module case_section(outer_dimensions, cut_at, lower=true) {
    case_z_offset = outer_dimensions.z / 2 - cut_at;
    cut_size = outer_dimensions + [2, 2, 2];
    cut_z_offset = cut_size.z / 2;
    cut_z_direction = lower ? +1 : -1;

    difference() {
        translate([0, 0, case_z_offset])
            case(outer_dimensions);

        translate([0, 0, cut_z_offset * cut_z_direction])
            cube(cut_size, center=true);
    }
}

module case_section_lower(outer_dimensions, cut_at) {
    translate([0, outer_dimensions.y / 2, cut_at - case_plate])
        difference() {

            union() {
                // the lower case part
                case_section(outer_dimensions, cut_at, lower=true);

                // the guiding spheres
                four_corners(hook_case_pillar_center)
                    sphere(d=screw_nut_diameter);
            }

            // cutout for screws, again due to the guiding spheres

            four_corners(hook_case_pillar_center)
                screw_and_nut_hole(length=outer_dimensions.z, center=true);
        }

}


module case_section_upper(outer_dimensions, cut_at) {

    inner_cut_height    = cut_at - case_plate;
    inner_cut_remaining = outer_dimensions.z - cut_at - case_plate;

    translate([0, outer_dimensions.y / 2, inner_cut_remaining])
        difference() {
            // the top case, rotated and aligned as I like it
            rotate([0, 180, 0]) {
                // the upper case part
                translate([0, 0, 0])
                    case_section(outer_dimensions, cut_at, lower=false);
            }

            // the guiding spheres
            four_corners(hook_case_pillar_center)
                sphere(d=screw_nut_diameter + screw_hole_slack);
        }
}


translate([-100, 0, 0]) case_section_lower(hook_case_outer, cut_at=5);
translate([- 50, 0, 0]) case_section(hook_case_outer, cut_at=5, lower=true);
translate([+ 50, 0, 0]) case_section(hook_case_outer, cut_at=5, lower=false);
translate([+100, 0, 0]) case_section_upper(hook_case_outer, cut_at=5);

difference() {
    cut_size = hook_case_outer + [2, 2, 2];
    case(hook_case_outer);
    translate([-cut_size.x / 2, -cut_size.y, 0])
        cube(cut_size);
}
