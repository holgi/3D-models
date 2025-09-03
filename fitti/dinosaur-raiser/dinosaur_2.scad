$fn = 120;
JOIN = 0.1;

plug_inner_diameter =   2.2;   // mm
plug_inner_to_flat  =   1.8;   // mm
plug_inner_height   =   2.0;   // mm

plug_base_diameter  =   4.0;   // mm
plug_base_height    =   5.0;   // mm

filament_diameter   =   1.85;  // mm
filament_slack      =   0.25;  // mm
filament_angle      =  17.5;   // degree

base_diameter       =  25.0;   // mm
base_height         =   3.0;   // mm

sphere_diameter = filament_diameter * 4;
sphere_offset = base_height - sphere_diameter / 10;

function vector(x) = [x, x, x];


module _lower_cut() {
    translate([0, 0, -base_diameter - 1])
        cube(vector(base_diameter + 1) * 2, center=true);
}

module base_plate() {
    difference() {
        translate([0, 0, -base_diameter * 0.4])
            sphere(r=base_diameter * .65);

        translate([0, 0, base_diameter + base_height + 1])
            cube(vector(base_diameter + 1) * 2, center=true);

        _lower_cut();
    }
}

module filament_sphere() {
    difference() {
        translate([0, 0, sphere_offset])
            sphere(d=sphere_diameter);

        _lower_cut();
    }
}

module filament_cutout() {
    difference() {
        translate([0, 0, sphere_offset])
            rotate([0, filament_angle, 0])
                translate([0, 0, - sphere_diameter / 2])
                    cylinder(d=filament_diameter + filament_slack, h=sphere_diameter * 2);

        translate([0, 0, 1])
            _lower_cut();
    }
}

module base_assembly() {
    difference() {
        union() {
            base_plate();
            filament_sphere();
        }
        filament_cutout();
    }
}


module plug() {
    translate([0, 0, -JOIN])
        difference() {
            cylinder(d=plug_inner_diameter, h=plug_inner_height + JOIN);

            cut = plug_inner_to_flat - plug_inner_diameter / 2;
            translate(vector(-10) - [0, 10 + cut, 0])
                cube(vector(2 * 10));
        }
}

//plug();

module _plug_base_full() {
    hull() {
        sphere(d=plug_base_diameter);
        cylinder(d=plug_base_diameter, h=plug_base_diameter / 2);
        rotate([0, 180-filament_angle, 0])
        cylinder(d=plug_base_diameter, h=plug_base_diameter / 2);
    }
    rotate([0, 180-filament_angle, 0])
        cylinder(d=plug_base_diameter, h=plug_base_height);
}

module _plug_base_filament() {
    difference() {
        _plug_base_full();
        rotate([0, 180-filament_angle, 0])
            cylinder(d=filament_diameter, h=plug_base_height + 1);
    }
}


difference() {
    cut = plug_inner_to_flat - plug_inner_diameter / 2;
    translate([0, 0, cut])
        rotate([90, 0, 0])
            union() {
                _plug_base_filament();

                translate([0, 0, plug_base_diameter / 2])
                    plug();
            }

            translate([0, 0, -10])
                cube(vector(2 * 10), center=true);
}
