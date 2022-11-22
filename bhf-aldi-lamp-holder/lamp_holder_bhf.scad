$fn = 60;

wall_width  =   2.5;  // mm
wall_height =  10;    // mm

lamp_base_width  =  46.5;  // mm
lamp_upper_width =  50;    // mmm
lamp_length      = 220;   // mm

screw_shaft = 3;  //  mm
screw_head  = 6;  //  mm


delta_base_upper = (lamp_upper_width - lamp_base_width);


module pillar() {
    hull() {
        sphere(d=wall_width);
        translate([0, delta_base_upper / 2, wall_height + wall_width])
            sphere(d=wall_width);
    }
}


module wall(x) {
    dx = x / 2;
    hull() {
        translate([-dx, 0, 0]) pillar();
        translate([+dx, 0, 0]) pillar();
    }
}


module corner_old(step=1) {
    for (a = [0 : step : 90]) {
        rotate([0, 0, a]) pillar();
    }
}

module corner() {

    lower = wall_width;
    upper_outer_diameter = lower + delta_base_upper;
    upper_inner_diameter = upper_outer_diameter - wall_width * 2;
    height_outer = wall_height + wall_width;
    height_inner = height_outer - wall_width / 2;
    cut_cube = height_outer * 4;
    difference() {
        union() {
            cylinder(height_outer, d1=lower, d2=upper_outer_diameter);
            sphere(d = lower);
        }
        translate([0, 0, wall_width / 2])
            cylinder(height_inner + .01, d1=0.5, d2=upper_inner_diameter);
        translate([cut_cube / 2, 0, 0])
            cube([cut_cube, cut_cube, cut_cube], center=true);
        translate([0, cut_cube / 2, 0])
            cube([cut_cube, cut_cube, cut_cube], center=true);
    }
    translate([0, 0, height_outer])
        rotate([0, 0, 180])
            rotate_extrude(angle=90)
                translate([delta_base_upper / 2, 0, 0])
                    circle(d=wall_width);

}


module all_walls() {
    dx = (lamp_length + wall_width) / 2;
    dy = (lamp_base_width + wall_width) / 2;
    translate([-dx, 0, 0]) rotate([0, 0, +90]) wall(dy * 2);
    translate([+dx, 0, 0]) rotate([0, 0, -90]) wall(dy * 2);
    translate([0, -dy, 0]) rotate([0, 0, 180]) wall(dx * 2);
    translate([0, +dy, 0]) wall(dx * 2);
    translate([-dx, -dy, 0]) rotate([0, 0, 0]) corner();
    translate([+dx, -dy, 0]) rotate([0, 0, 90]) corner();
    translate([+dx, +dy, 0]) rotate([0, 0, 180]) corner();
    translate([-dx, +dy, 0]) rotate([0, 0, 270]) corner();
}


module shell() {
    all_walls();
    translate([0, 0, wall_width / 2])
    cube([lamp_length + wall_width, lamp_base_width + wall_width, 2 * wall_width], center=true);
}


module sensor_cut() {
    y = lamp_base_width / 2;
    x = lamp_length / 2;
    z = wall_height / 2 + wall_width * 1.5 + 0.1;
    translate([-x, -y / 2 + 1, z])
        cube([10, y, wall_height + 0.2], center=true);
}


module zip_tie_cut(off=30) {
    dx = lamp_length / 2 - off;
    translate([dx, 0, 0])
        cube([10, lamp_upper_width + 10, wall_width + 0.1], center=true);
}


module screw(length) {
    upper = screw_head + 1;
    lower = screw_shaft;
    h = upper - lower;
    cylinder(length, d=lower, center=true);
    translate([0, 0, length / 2 - h])
        cylinder(h, d1=lower, d2=upper);
}

module double_screw(off=30) {
    length = wall_width * 2 + 1;
    dx = lamp_length / 2 - off;
    translate([dx - off / 2, 0, wall_width / 2]) screw(length);
    translate([dx + off / 2, 0, wall_width / 2]) screw(length);
}


module assembly() {
    difference() {
        shell();
        sensor_cut();
        zip_tie_cut();
        double_screw();
        rotate([0, 0, 180]) {
            sensor_cut();
            zip_tie_cut();
            double_screw();
        }
    }
}

module print() {
    off = 30;
    difference() {
        assembly();
        translate([-off * 2 +  1, 0, wall_height / 2])
            cube([lamp_length, lamp_base_width * 2, wall_height * 3], center=true);
    }
}

print();



