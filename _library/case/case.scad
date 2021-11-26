/*

Creates a nice case consisting of top and lower part
With reinforcements, screw holes and a sloping top corners.


The resulting forms will be centered on x- and y-axis
The usable side of the floor / celing of the case will be on z=0

 - `case_both_parts()`: generates both parts of the case side by side
 - `case_lower_part()`: generates the lower part of the case
 - `case_upper_part()`: generates the upper part of the case

The following parameters define the box and can be supplied to the modules:

    dimensions:        vector for [length, width, height], same as in cube()
    wall:              wall size of the box  [default=3]
    lid:               thickness of the floor or ceiling  [default=2]
    corner:            corner radius of the box  [default=5]
    screw:             diameter of the screw  [default=3, as in M3]
    screw_wall:        minimum thickness of material around the screw  [default=3]
    screw_head_dia:    diameter of the screw head  [default=5.5, for a M3]
    screw_head_height: height of the screw head, [default=3.5, for a M3]
*/

$fn = 120;

CORNER_VECTORS = [
    [+1, +1,   0],
    [-1, +1,  90],
    [-1, -1, 180],
    [+1, -1, 270]
];

JOIN = 0.01;

/* calculations for corner reinforcements / screw mounts */
function outer_corner_offset(corner) = corner - sin(45) * corner;
function screw_diagonal_offset(screw) = screw * sqrt(1/2);
function inner_reinforcement_offset(screw, corner) = screw_diagonal_offset(screw) + outer_corner_offset(corner);
function min_reinforcement_radius(screw, corner, wall) = (inner_reinforcement_offset(screw, corner) - wall) / sin(45);
function reinforcement_radius(screw, corner, wall) = max(min_reinforcement_radius(screw, corner, wall), corner - wall);

/* calculate the center of a screw */
function lower_pos_offset(screw, corner, wall) = sin(45) * reinforcement_radius(screw, corner, wall) + wall;
function screw_center_offset(screw, corner, wall) = (lower_pos_offset(screw, corner, wall) + outer_corner_offset(corner)) / 2;


module round_rect(dimensions, corner=5) {
    /* basic form for the case

    The resulting form will be centered

    dimensions: vector for [length, width, height], same as in cube()
    corner:     corner radius
    */
    length = dimensions[0];
    width = dimensions[1];
    height = dimensions[2];

    l_wo_corner = length - 2 * corner;
    w_wo_corner = width - 2 * corner;
    cube([length, w_wo_corner, height], center=true);
    cube([l_wo_corner, width, height], center=true);

    corner_offset_x = l_wo_corner / 2;
    corner_offset_y = w_wo_corner / 2;
    for (cv = CORNER_VECTORS) {
        translate([cv[0] * corner_offset_x, cv[1] * corner_offset_y, 0])
            cylinder(height, d=corner*2, center=true);
    }
}


module round_rect_box(dimensions, wall=3, lid=2, corner=5) {
    /* a basic box

    The resulting form will be centered

    dimensions: vector for [length, width, height], same as in cube()
    wall:       wall thickness
    corner:     corner radius
    */
    inner_length = dimensions[0] - 2 * wall;
    inner_width = dimensions[1] - 2 * wall;
    inner_height = dimensions[2];
    inner_corner = corner - wall;
    difference() {
        round_rect(dimensions, corner);
        if (corner > wall) {
            translate([0, 0, lid])
                round_rect([inner_length, inner_width, inner_height], inner_corner);
        } else {
            translate([0, 0, lid])
                cube([inner_length, inner_width, inner_height], center=true);
        }
    }
}


module quarter_cylinder(height, diameter) {
    /* helper module for a quarter of a cylinder

    Think as in a quarter of the pizza ;-)

    height:   height of the cylinder
    diameter: diameter of the cylinder
    */
    difference(){
        cylinder(height, d=diameter, center=true);
        translate([diameter / 2, 0, 0])
            cube([diameter, diameter, height + JOIN], center=true);
        translate([0, diameter / 2, 0])
            cube([diameter, diameter, height + JOIN], center=true);
    }
}


module quarter_cylinder_negative(height, diameter) {
    /* helper module for the negative form of a quarter of a cylinder

    Think as in a quarter of the pizza ;-)

    height:   height of the cylinder
    diameter: diameter of the cylinder
    */
    difference() {
        translate([diameter/2, diameter/2, 0])
            cube([diameter, diameter, height], center=true);
        translate([-JOIN, -JOIN, 0])
            cylinder(height + JOIN, d=diameter, center=true);
    }
}


module corner_reinforcement(height, diameter=false, wall=3, corner=5) {
    /* reinforcement in the corners, could also contain the screw holes

    height:   height of the reinforcement
    diameter: diameter to use, directed at the inside of the box
    wall:     wall size of the box
    corner:   corner radius of the box
    */
    used_diameter = (diameter) ? diameter : (corner - wall) * 2;
    inner_radius = used_diameter / 2;
    difference() {
        translate([corner - wall, corner - wall, 0])
            quarter_cylinder(height, used_diameter);
        quarter_cylinder_negative(height + JOIN, corner * 2);
    }
}


module screw_reinforcements(dimensions, wall=3, corner=5, screw=3, screw_wall=3) {
    /* reinforcements in the corners, large enough to contain screw holes

    dimensions: vector for [length, width, height], same as in cube()
    wall:       wall size of the box
    corner:     corner radius of the box
    screw:      diameter of the screw, defaults to M3
    screw_wall: minimum thickness of material around the screw
    */
    inner_corner = corner - wall;
    screw_container_diameter = screw + screw_wall * 2;
    used_radius = reinforcement_radius(screw_container_diameter, corner, wall);

    rein_x = dimensions[0] / 2 - inner_corner - wall;
    rein_y = dimensions[1] / 2 - inner_corner - wall;
    for (v = CORNER_VECTORS) {
        translate([v[0] * rein_x, v[1] * rein_y, 0])
            rotate([0, 0, v[2]])
            corner_reinforcement(dimensions[2], used_radius * 2, wall, corner);
    }
}


module case_part(dimensions, wall=3, lid=2, corner=5, screw=3, screw_wall=3) {
    /* blank upper or lower part with screw reinforcements

    the resulting height will be a little bit higher to accomodate
    the diagonal inset later.

    dimensions: vector for [length, width, height], same as in cube()
    wall:       wall size of the box
    lid:        thickness of the floor or ceiling
    corner:     corner radius of the box
    screw:      diameter of the screw, defaults to M3
    screw_wall: minimum thickness of material around the screw
    */

    slope_height = wall / 2;
    dimensions_with_slope = [
        dimensions[0],
        dimensions[1],
        dimensions[2] + slope_height,
    ];
    round_rect_box(dimensions_with_slope, wall, lid, corner);
    screw_reinforcements(dimensions_with_slope, wall, corner, screw, screw_wall);
}


module slope_cutout_form(dimensions, wall=3, corner=5) {
    /* the basic diagonal inset form, used to create cutout forms

    dimensions: vector for [length, width, height], same as in cube()
    wall:       wall size of the box
    corner:     corner radius of the box
    */
    delta=1;  // adds a little bit more to all dimensions of the form
    length = dimensions[0] + delta;
    width = dimensions[1] + delta;
    height = wall + delta;

    l_wo_corner = dimensions[0] - corner * 2;
    w_wo_corner = dimensions[1] - corner * 2;

    lower_radius = corner + delta/2;
    upper_radius = max(0, lower_radius - wall - delta);

    corner_height = lower_radius - upper_radius;
    corner_offset_x = length / 2 - lower_radius;
    corner_offset_y = width / 2 - lower_radius;
    corner_offset_z = (height - corner_height) / 2;

    cut_size = max(length, width, height);
    cut_offset = cut_size / 2;

    difference () {
        union() {
            for (cv = CORNER_VECTORS) {
                translate([cv[0] * corner_offset_x, cv[1] * corner_offset_y, -corner_offset_z])
                    cylinder(corner_height, lower_radius, upper_radius, center=true);
            }

            cube([length, w_wo_corner, height], center=true);
            cube([l_wo_corner, width, height], center=true);
        }
        translate([0, width / 2 + JOIN, -height / 2 - JOIN])
            rotate([-45, 0, 0])
            translate([0, -cut_offset, cut_offset])
            cube([cut_size, cut_size, cut_size], center=true);

        translate([0, -width / 2 - JOIN, -height / 2 - JOIN])
            rotate([45, 0, 0])
            translate([0, cut_offset, cut_offset])
            cube([cut_size, cut_size, cut_size], center=true);

        translate([length / 2 + JOIN, 0, -height / 2 - JOIN])
            rotate([0, 45, 0])
            translate([-cut_offset, 0, cut_offset])
            cube([cut_size, cut_size, cut_size], center=true);

        translate([-length / 2 - JOIN, 0, -height / 2 - JOIN])
            rotate([0, -45, 0])
            translate([cut_offset, 0, cut_offset])
            cube([cut_size, cut_size, cut_size], center=true);
    }


}

module slope_inset_cutout(dimensions, wall=3, corner=5) {
    /* negative form for the slope inset of the lower box part

    dimensions: vector for [length, width, height], same as in cube()
    wall:       wall size of the box
    corner:     corner radius of the box
    */
    slope_height = wall / 2;
    cube_dimensions = [
        dimensions[0] + JOIN,
        dimensions[1] + JOIN,
        wall + JOIN,
    ];
    difference() {
        cube(cube_dimensions, center=true);
        translate([0, 0, 0])
            slope_cutout_form(dimensions, wall, corner);
    }
}

module slope_outset_cutout(dimensions, wall=3, corner=5) {
    /* negative form for the slope outset of the upper box part

    dimensions: vector for [length, width, height], same as in cube()
    wall:       wall size of the box
    corner:     corner radius of the box
    */

    slope_height = wall / 2;
    cube_dimensions = [
        dimensions[0] + JOIN,
        dimensions[1] + JOIN,
        slope_height + JOIN,
    ];
    difference() {
        slope_cutout_form(dimensions, wall, corner);
        translate([0, 0, (wall + slope_height) / 2 + JOIN])
            cube(cube_dimensions, center=true);
    }
}


module case_lower_part(dimensions, wall=3, lid=2, corner=5, screw=3, screw_wall=3) {
    /* lower part of the case

    With reinforcements, screw holes and a sloping top corner.

    The resulting form will be centered on x- and y-axis
    The top of the floor of the case will be on z=0

    dimensions: vector for [length, width, height], same as in cube()
    wall:       wall size of the box
    lid:        thickness of the floor or ceiling
    corner:     corner radius of the box
    screw:      diameter of the screw, defaults to M3
    screw_wall: minimum thickness of material around the screw
    */
    slope_height = wall / 2;
    z_offset = (dimensions[2] + slope_height) / 2 - lid;
    translate([0, 0, z_offset]) {
        difference() {
            case_part(dimensions, wall, lid, corner, screw, screw_wall);

            translate([0, 0, (dimensions[2] - slope_height) / 2])
                slope_inset_cutout(dimensions, wall, corner);

            screw_container_diameter = screw + screw_wall * 2;
            screw_offset = screw_center_offset(screw_container_diameter, corner, wall);
            screw_x = dimensions[0] / 2 - screw_offset;
            screw_y = dimensions[1] / 2 - screw_offset;
            for (v = CORNER_VECTORS) {
                translate([v[0] * screw_x, v[1] * screw_y, lid])
                    cylinder(h=dimensions[2], d=screw, center=true);
            }
        }
    }
}

module case_upper_part(dimensions, wall=3, lid=2, corner=5, screw=3, screw_wall=3, screw_head_dia=5.5, screw_head_height=3) {
    /* upper part of the case

    With reinforcements, screw holes and a sloping top corner.

    The resulting form will be centered on x- and y-axis
    The bottom of the celing of the case will be on z=0

    dimensions:        vector for [length, width, height], same as in cube()
    wall:              wall size of the box
    lid:               thickness of the floor or ceiling
    corner:            corner radius of the box
    screw:             diameter of the screw, defaults to M3
    screw_wall:        minimum thickness of material around the screw
    screw_head_dia:    diameter of the screw head, defaults to M3
    screw_head_height: height of the screw head, defaults to M3
    */
    slope_height = wall / 2;
    z_offset = (dimensions[2] + slope_height) / 2 - lid;
    translate([0, 0, z_offset]) {
        difference() {
            case_part(dimensions, wall, lid, corner, screw, screw_wall);

            translate([0, 0, (dimensions[2]- slope_height)/2])
                rotate([180,0,0])
                slope_outset_cutout(dimensions, wall, corner);

            slope_height = wall / 2;
            screw_container_diameter = screw + screw_wall * 2;
            screw_offset = screw_center_offset(screw_container_diameter, corner, wall);
            screw_x = dimensions[0] / 2 - screw_offset;
            screw_y = dimensions[1] / 2 - screw_offset;
            screw_head_z = (dimensions[2] - screw_head_height + slope_height) / 2;
            screw_slack_diameter = screw + 0.5;
            screw_head_slack_diameter = screw_head_dia + 0.5;
            height = dimensions[2] + wall / 2;
            for (v = CORNER_VECTORS) {
                translate([v[0] * screw_x, v[1] * screw_y, -JOIN])
                    cylinder(h=height, d=screw_slack_diameter, center=true);
                translate([v[0] * screw_x, v[1] * screw_y, -screw_head_z - JOIN])
                    cylinder(h=screw_head_height, d=screw_head_slack_diameter, center=true);
            }
        }
    }
}


module case_both_parts(lower, upper, wall=3, lid=2, corner=5, screw=3, screw_wall=3, screw_head_dia=5.5, screw_head_height=3.5) {
    /* lower and upper part of the case

    With reinforcements, screw holes and a sloping top corners.
    Both cases are 10mm apart.

    The resulting form will be centered on x- and y-axis
    The usable side of the floor / celing of the case will be on z=0

    dimensions:        vector for [length, width, height], same as in cube()
    wall:              wall size of the box
    lid:               thickness of the floor or ceiling
    corner:            corner radius of the box
    screw:             diameter of the screw, defaults to M3
    screw_wall:        minimum thickness of material around the screw
    screw_head_dia:    diameter of the screw head, defaults to M3
    screw_head_height: height of the screw head, defaults to M3
    */
    slope_height = wall / 2;
    dz_lower = (lower[2] + slope_height) / 2;
    dz_upper = (upper[2] + slope_height) / 2;

    translate([0, -lower[1] / 2 - 5, 0])
        case_lower_part(lower, wall, lid, corner, screw, screw_wall);
    translate([0, upper[1] / 2 + 5, 0])
        case_upper_part(upper, wall, lid, corner, screw, screw_wall, screw_head_dia, screw_head_height);
}


lower = [80, 40, 10];
upper = [80, 40, 10];
case_both_parts(lower, upper, wall=3, corner=5, screw=3);

