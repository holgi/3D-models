/*

A holder for the Eufy H30 brush that came with the motorized brush

*/

$fn = 120;

plug_x = 38;
plug_z = 11.5;
plug_r = 160;

plug_cut_z = 13;
plug_cut_delta = 1.5;

brush_x = 23;
brush_y = 5;
brush_z = 25;

z_total = plug_z + brush_z;


module half_cylinder(diameter, height=plug_z) {
    cut_diameter = diameter + 1;
    difference() {
        cylinder(height, d=diameter);
        translate([-cut_diameter / 2, -diameter, -1])
            cube([cut_diameter, diameter, height + 2]);
    }
}


module separated(diameter, height=plug_z) {
    intersection() {
        translate([(diameter / 2 - plug_x / 2), 0, 0])
            half_cylinder(diameter);
        translate([(-diameter / 2 + plug_x / 2), 0, 0])
            half_cylinder(diameter);
    }
}


module plug_base(x=plug_x, site_r=plug_x*2, top_r=plug_r, height=plug_z) {
    dy = plug_cut_z + plug_cut_delta - top_r / 2;
    intersection() {
        separated(site_r);
        translate([0, dy, 0])
            half_cylinder(top_r);
    }
}


module plug(height, delta=1) {
    linear_extrude(height=height)
        offset(r=delta)
            projection()
                plug_base();
}

difference() {
    plug(z_total, 2);
    translate([0, 0, -.1])
        plug(plug_z, 0.5);
    translate([0, 6.25, z_total / 2])
        linear_extrude(height=z_total + 1, center=true, scale=1.2)
            square([brush_x, brush_y], center=true);
}
