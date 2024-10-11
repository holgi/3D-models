use<dw-library/rounded_cube/rounded_cube.scad>;

module four_corners(v, radius) {
    x_offset = v.x / 2 - radius;
    y_offset = v.y / 2 - radius;

    for (x=[-x_offset, +x_offset]) {
        for (y=[-y_offset, +y_offset]) {
            translate([x, y, 0])
                children();
        }
    }
}


module four_pillars(v, radius) {
    four_corners(v, radius)
        cylinder(v.z, r=radius);
}


module box(outer_vector, radius, inset, z_radius=box_z_radius) {
    inner_vector = [outer_vector.x - 2 * wall_width, outer_vector.y - 2 * wall_width, outer_vector.z];
    difference() {
        translate([-outer_vector.x / 2, -outer_vector.y / 2, 0])
            rounded_cube(outer_vector, radius, top_radius=0, bottom_radius=z_radius);
        translate([-inner_vector.x / 2, -inner_vector.y / 2, wall_width])
            rounded_cube(inner_vector, radius - wall_width, top_radius=0, bottom_radius=z_radius);
    }
}


module ridge(length, diameter) {
    adjusted_length = length - diameter;
    cylinder(adjusted_length, d=diameter, center=true);
    for(i=[-1, 1]) {
        translate([0, 0, i * adjusted_length / 2])
            sphere(d=diameter);
    }
}


module case(outer_vector, radius, inset, sphere_diameter, lower=true) {

    screw_length = outer_vector.z + sphere_diameter + 1;
    ridge_diameter = inset / 2;

    module _base_box(outer_vector, radius, inset) {
        box(outer_vector, radius, inset);
        translate([0, 0, box_z_radius])
            four_pillars([outer_vector.x, outer_vector.y, outer_vector.z - box_z_radius], radius);
    }

    module _spheres(outer_vector, radius, sphere_diameter) {
        translate([0, 0, outer_vector.z])
            four_corners(outer_vector, radius)
                sphere(d=sphere_diameter);
    }

    module _ridges(outer_vector, length, diameter)  {
        // guiding ridges
        translate([-ridge_offset, 0, outer_vector.z])
            rotate([90, 0, 0])
                ridge(length, diameter);

        translate([+ridge_offset, 0, outer_vector.z])
            rotate([90, 0, 0])
                ridge(length, diameter);
    }

    if (lower) {
        difference() {
            union() {
                _base_box(outer_vector, radius, inset);
                _spheres(outer_vector, radius, sphere_diameter);
            }
            _ridges(outer_vector, ridge_length, diameter=ridge_diameter + 0.2);

            // screw and nut holes
            four_corners(hook_box_lower_part, radius)
                screw_and_nut_hole(screw_length);
        }
    } else {
        difference() {
            union() {
                _base_box(outer_vector, radius, inset);
                _ridges(outer_vector, ridge_length - 2, ridge_diameter);
            }
            _spheres(outer_vector, radius, sphere_diameter + 0.2);

            // screw and nut holes
            four_corners(outer_vector, radius)
                rotate([180, 0, 0])
                    translate([0, 0, -screw_length])
                        screw_and_nut_hole(screw_length);
        }
    }
}
