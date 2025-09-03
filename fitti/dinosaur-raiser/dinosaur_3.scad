$fn = 120;
JOIN = 0.1;

plug_inner_diameter =   2.2;   // mm
plug_inner_to_flat  =   1.8;   // mm
plug_inner_height   =   2.0;   // mm

plug_base_diameter  =   4.0;   // mm
plug_base_height    =   5.0;   // mm

stem_height         =  65.0;  // mm
stem_radius         =  65.0;  // mm

base_diameter       =  30.0;  // mm
base_height         =   3.0;  // mm


cut_flat = plug_inner_diameter - plug_inner_to_flat;

function vector(x) = [x, x, x];


module _lower_cut() {
    translate([0, 0, -base_diameter - 1])
        cube(vector(base_diameter + 1) * 2, center=true);
}


module plug() {
    difference() {
    translate([0, 0, -JOIN])
        cylinder(d=plug_inner_diameter, h=plug_inner_height + JOIN);

        cut_y = (plug_inner_diameter / 2) - cut_flat;
        translate([-10, -20 - cut_y, -10])
            cube(vector(20));
    }
}


module rounded_end_cylinder(diameter=plug_inner_to_flat, height=plug_inner_height) {
    radius = diameter / 2;
    translate([0, 0, radius])
        sphere(d=diameter);
    translate([0, 0, radius])
        cylinder(d=diameter, h=height - radius + JOIN);
}


module plug_base(height=plug_inner_to_flat) {
    diameter = plug_inner_to_flat;
    radius = diameter / 2;

    translate([0, 0, -JOIN]) {
        translate([-diameter, 0, 0])
            rounded_end_cylinder(diameter=diameter, height=height);

        translate([+diameter, 0, 0])
                rounded_end_cylinder(diameter=diameter, height=height);

        translate([-diameter, 0, radius])
            rotate([0, 90, 0])
                cylinder(d=diameter,  h=diameter * 2);

        translate([-diameter, -radius, radius])
            cube([diameter * 2, diameter, (height - radius) + JOIN]);
    }

}


module base_stem_2d(scale_x=2.5) {
    difference() {
        circle(r=stem_radius);

        translate([-plug_inner_to_flat / (scale_x / 2), plug_inner_to_flat * 0.4, 0])
            circle(r=stem_radius);

        translate([-1, stem_height / 2, 0])
            square([stem_radius + 1, stem_radius]);
        translate([-1, -stem_radius - stem_height / 2, 0])
            square([stem_radius + 1, stem_radius]);
        translate([-stem_radius - 1, -stem_radius, 0])
            square([stem_radius + 1, stem_radius * 2]);
    }
}



module stem(scale_x=2.5, width=plug_inner_to_flat) {
    sin_x = ((stem_height / 2) / stem_radius);
    angle_x = asin(sin_x);
    arc_x = cos(angle_x)  * stem_radius;
    dx = arc_x * scale_x ;

    translate([0, 0, -JOIN])
        rotate([90, 0, 0])
            translate([-dx, stem_height / 2, -width / 2])
                scale([scale_x, 1, 1])
                    linear_extrude(width)
                        base_stem_2d(scale_x=scale_x);
}

module _stem_assembly() {
    translate([-0.7, 0, stem_height]) {
        translate([0, -cut_flat / 2, 0])
            plug();
        translate([0, 0, -plug_inner_to_flat])
            plug_base();
    }
    stem();
}

module stem_assembly() {
    rotate([90, 0, 0])
        difference()  {
            _stem_assembly();

            translate([0, 0, -4.5])
                cube(vector(10), center=true);
        }
}


module base_plate() {
    difference() {
        translate([0, 0, -base_diameter * 0.4])
            sphere(r=base_diameter * .65);

        translate([0, 0, -base_diameter - 1])
            cube(vector(base_diameter + 1) * 2, center=true);
        translate([0, 0, base_diameter + base_height + 1])
            cube(vector(base_diameter + 1) * 2, center=true);


        stem(width=plug_inner_to_flat + 0.15);
        translate([1, 0, 0])
            stem(width=plug_inner_to_flat + 0.0);
    }
}



stem_assembly();

!rotate([0, 0, -90]) base_plate();
