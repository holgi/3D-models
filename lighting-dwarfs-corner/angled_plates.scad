function join_width(width, angle) =
    let (half_angle = angle / 2)
    let (x_cut = width / cos(half_angle))
    x_cut / tan(half_angle);


module angled_plate_round_corner(diameter=5, angle=45, length=100) {
    radius = diameter / 2;
    half_angle = angle / 2;
    x_width = cos(half_angle) * diameter;
    y_height = (x_width / 2) / tan(half_angle);
    y_cylinder_offset = sin(half_angle) * radius;
    translate([0, 0, -y_height]) {
        difference() {
            translate([-x_width/2, 0, 0]) {
                cube([x_width, length, y_height]);
            }
            translate([0, -5, -y_cylinder_offset]) {
                rotate([-90, 0, 0]){
                    cylinder(length + 10, radius, radius);
                }
            }
        }
    }
}


module angled_plates_helper(length=100, height=50, width=10, angle=85, corner_diameter=5) {
    half_angle = angle / 2;
    z_offset = join_width(width, angle);
    union() {
        rotate([0, half_angle, 0]) {
            translate([-0, 0, -height]) {
                cube ([width, length, height]);
            }
        }
        rotate([0, -half_angle, 0]) {
            translate([-width, 0, -height]) {
                cube ([width, length, height]);
            }
        }
        translate([0,0, -z_offset]) {
            angled_plate_round_corner(corner_diameter, angle, length);
        }
    }
}

module angled_plates(length=100, height=50, width=10, angle=85, outer_diameter=10, inner_diameter=5) {
    half_angle = angle/2;
    z_offset = join_width(width, angle);
    rotate([0 ,-half_angle-90, 0]) {
        union() {
            difference () {
                angled_plates_helper(length, height, width, angle, inner_diameter);
                translate([0, -1, z_offset]) {
                    angled_plates_helper(length+2, height, width, angle, outer_diameter);
                }
            }
        }
    }
}

angled_plates();

