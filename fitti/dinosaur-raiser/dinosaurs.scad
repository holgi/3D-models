$fn = 120;
JOIN = 0.1;


plug_inner_diameter =   2.1;  // mm
plug_inner_to_flat  =   1.8;  // mm
plug_inner_height   =   2.0;  // mm

plug_base_diameter  =   4.0;  // mm
plug_base_height    =   2.0;  // mm

stem_height         =  60.0;  // mm
stem_width          =   5.0;  // mm
stem_radius         =  60.0;  // mm

base_diameter       =  30.0;  // mm
base_height         =   3.0;  // mm

connector_slack     =   0.1;  // mm


function vector(x) = [x, x, x];

module adjust_join() {
    translate([0, 0, -JOIN]) children();
}


module plug() {
    rotate([0, 0, 180])
        difference() {
            adjust_join()
                cylinder(d=plug_inner_diameter, h=plug_inner_height + JOIN);

            cut_y = plug_inner_diameter / 2 - plug_inner_to_flat;
            pid = plug_inner_diameter;
            translate([-pid, -cut_y, -pid])
                 cube(vector(pid*2) * 2);
            }
}


module plug_base() {
    adjust_join() {
        intersection(){
            octagon_half_angle = 360 / 8 / 2;
            octagon_diameter = plug_base_diameter / cos(octagon_half_angle);
            rotate([0, 0, octagon_half_angle])
                cylinder(d=octagon_diameter, h=plug_base_height + JOIN, $fn=8);

            translate([0, plug_base_diameter / 2, plug_base_diameter / 2])
                rotate([90, 0, 0])
                    cylinder(d=plug_base_diameter + JOIN * 2, h=plug_base_diameter);
        }

        translate([0, -plug_base_diameter / 2, 0])
            cube([plug_base_diameter / 2, plug_base_diameter, plug_base_height + JOIN]);
    }
}

module base_stem_2d(scale_x=2.5) {
    difference() {
        circle(r=stem_radius);

        translate([-stem_width / scale_x, stem_width * 0.4, 0])
            circle(r=stem_radius);

        translate([-1, stem_height / 2, 0])
            square([stem_radius + 1, stem_radius]);
        translate([-1, -stem_radius - stem_height / 2, 0])
            square([stem_radius + 1, stem_radius]);
        translate([-stem_radius - 1, -stem_radius, 0])
            square([stem_radius + 1, stem_radius * 2]);
    }
}


module stem(scale_x=2.5) {
    sin_x = ((stem_height / 2) / stem_radius);
    angle_x = asin(sin_x);
    arc_x = cos(angle_x)  * stem_radius;
    dx = arc_x * scale_x ;

    difference() {
        translate([2, 0, 0])
            rotate([90, 0, 0])
                translate([-dx, stem_height / 2, -plug_base_diameter/2])
                    scale([scale_x, 1, 1])
                        linear_extrude(plug_base_diameter)
                            base_stem_2d(scale_x=scale_x);

        translate([0, 0, -base_diameter + base_height])
            cube(vector(base_diameter * 2), center=true);
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


        connector(slack=connector_slack);
    }
}


module connector(slack=0) {

    width = plug_base_diameter - 1 + slack * 2;
    height = base_height + JOIN + slack * 2;

    translate([-2, 0, -slack]) {
        cylinder(d=width, h=height);

        translate([-3, 0, 0])
            cylinder(d=width, h=height);

        translate([-3, -width / 2, 0])
            cube([3, width, height]);
        }
}


module raiser_assembly() {
    translate([-5 ,0 ,0]) {
        translate([0, 0, stem_height]) {
            plug();
            translate([0, 0, -plug_base_height]) plug_base();
        }
        stem(scale_x=2);
    }
    connector();
}

module full_assembly() {
    raiser_assembly();
    base_plate();
}



translate([ 0, 0, 0]) raiser_assembly();
//translate([+20, 0, 0]) base_plate();
