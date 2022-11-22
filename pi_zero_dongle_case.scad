$fn = 60;

wall             =  1.6;  // mm
clip_stem_width  =  1.6;  // mm

pi0_width        = 32;    // mm, including usb stubs
pi0_length       = 61;    // mm, including camera protector
pi0_height       = 12;    // mm, including headers
pi0_board        =  1.5;  // mm
pi0_board_offset =  2;    // mm
pi0_srew_delta   =  3;    // mm
pi0_solder       =  1.6;  // mm

pi0_plug_length  =  8;    // mm
pi0_plug_width   =  1.5;  // mm
pi0_plug_height  =  3;    // mm
pi0_plug_1_delta =  7;    // mm
pi0_plug_2_delta =  5.5;  // mm

plug_length      = 14;    // mm
plug_width       =  5;    // mm
plug_height      =  8.5;  // mm
plug_xtra_height =  5;    // mm

dongle_offset    =  5;    // mm
dongle_solder    =  1.6;  // mm

usb_width        = 12;    // mm
usb_height       =  5;    // mm
usb_front_offset = 24;    // mm

screw_thread     =  2.5;  // mm
screw_head       =  5;    // mm


//  calculated globals
plug1_x_offset     = pi0_length - (pi0_plug_1_delta + pi0_plug_length);
plug2_x_offset     = plug1_x_offset - (pi0_plug_2_delta + pi0_plug_length);
connector_x_offset = plug2_x_offset - (plug_length - pi0_plug_length) / 2;
dongle_length      = connector_x_offset + plug_length;
dongle_height      = dongle_offset + dongle_solder;
dongle_z_offset    = (dongle_height - pi0_solder);
usb_z_offset       = dongle_z_offset - dongle_solder;
usb_y_offset       = (pi0_width - usb_width) / 2;

case_width         = pi0_width + 2 * wall;
case_base_length   = pi0_length + wall;

bottom_case_height = dongle_height + wall;
top_case_height    = pi0_height - dongle_solder + wall;

module pi0() {
    cube([pi0_length, pi0_width, pi0_height]);

    plug_z_offset = pi0_board + pi0_board_offset;

    translate([plug1_x_offset, -pi0_plug_width - 1, plug_z_offset - 2]) {
        cube([pi0_plug_length, pi0_plug_width + 2, pi0_plug_height + 2]);
    }
    translate([plug2_x_offset, - pi0_plug_width, plug_z_offset]) {
        cube([pi0_plug_length, pi0_plug_width +1, pi0_plug_height]);
    }
}


module dongle() {
    // connector to pi0
    translate([connector_x_offset, -plug_width, -dongle_z_offset])
        cube([plug_length, plug_width + 1, dongle_height+ plug_xtra_height]);

    // base board
    translate([0, 0, -dongle_z_offset])
        cube([dongle_length, pi0_width, dongle_height]);
    translate([0, pi0_width / 2, -dongle_z_offset])
        cylinder(dongle_height, d=pi0_width);

    // usb connector
    translate([-usb_front_offset, usb_y_offset, -usb_z_offset])
        cube([usb_front_offset, usb_width, usb_height]);
}

module pi0_with_dongle() {
    pi0();
    dongle();
}

module pi0_cut() {
    pi0();
    dongle();
    translate([0, 0, -dongle_z_offset])
        cube([pi0_length, pi0_width, dongle_height]);
    translate([0, pi0_width / 2, -dongle_z_offset])
        cylinder(dongle_offset + pi0_height, d=pi0_width);
}


module base_case(height) {
    translate([0, -wall, 0]) {
        hull() {
            cube([case_base_length - wall, case_width, height]);
            translate([case_base_length - wall, wall, 0])
                cylinder(height, r = wall);
            translate([case_base_length - wall, case_width - wall, 0])
               cylinder(height, r = wall);
        }
        translate([0, case_width / 2, 0])
            cylinder(height, d=case_width);
    }
}


module screw_raiser(height) {
    translate([-4, 4, 0]) {
        cylinder(height, d=6);
        translate([0, -5, 0])
            cube([4, 6 + 2, height]);
        translate([-3, -5, 0])
            cube([6 + 1, 5, height]);
    }
}


module bottom_clips() {
    radius_lower = (pi0_width + wall) / 2;
    radius_upper = radius_lower - 3;
    difference() {
        cylinder(1, radius_lower, radius_lower);
        translate([0, 0, -1])
            cylinder(3, radius_lower, radius_upper);
        translate([-20, -usb_width/2, -20])
            cube([40, usb_width, 40]);
        rotate([0, 0, 45])
            translate([0, -20, -20])
                cube([40, 40, 40]);
        rotate([0, 0, -45])
            translate([0, -20, -20])
                cube([40, 40, 40]);
    }
}


module bottom_base_case() {
    bottom_case_offset = dongle_z_offset + wall;
    difference() {
        translate([0, 0, -bottom_case_offset - 0.01])
            base_case(bottom_case_height);
        pi0_cut();
    }

    translate([0, pi0_width / 2, -1 + dongle_solder])
        bottom_clips();

    translate([case_base_length - wall, 0, -bottom_case_offset])
        screw_raiser(bottom_case_height);
    translate([case_base_length - wall, pi0_width, -bottom_case_offset])
        rotate([0, 0, 90])
            screw_raiser(bottom_case_height);

}


module bottom_case() {
    difference() {
        bottom_base_case();
        translate([case_base_length - wall - 4.25, 4.25, -dongle_z_offset])
            cylinder(bottom_case_height, d=screw_thread - 0.1);
        translate([case_base_length - wall - 4.25, pi0_width - 4.25, -dongle_z_offset])
            cylinder(bottom_case_height, d=screw_thread - 0.1);
    }
}


module top_base_case() {
    difference() {
        translate([0, 0, dongle_solder])
            base_case(top_case_height);
        pi0_cut();

    }

    // screw raiser
    screw_height = top_case_height - pi0_board;
    screw_z_offset = dongle_solder + pi0_board;
    translate([case_base_length - wall, 0, screw_z_offset])
        screw_raiser(screw_height);
    translate([case_base_length - wall, pi0_width, screw_z_offset])
        rotate([0, 0, 90])
            screw_raiser(screw_height);
}

module top_clips() {
    difference() {
        translate([0, 0, 0.2])
            cylinder(top_case_height + 0.2, d=pi0_width + wall - 1);
        translate([0, 0, -2])
            cylinder(top_case_height + 4, d=pi0_width - 4);
        translate([-20, (-usb_width - 1)/2, -20])
            cube([40, usb_width + 1, 40]);
        rotate([0, 0, 46])
            translate([0, -20, -20])
                cube([40, 40, 40]);
        rotate([0, 0, -46])
            translate([0, -20, -20])
                cube([40, 40, 40]);
        bottom_clips();
    }
}


module top_case() {
    screw_z_offset = dongle_solder + pi0_board;
    head_z_offset = top_case_height + dongle_solder - 9.5;
    difference() {
        top_base_case();

        // screw hole with head sunk
        translate([case_base_length - wall - 4.25, 4.25, dongle_solder])
            cylinder(top_case_height, d=screw_thread + 0.2);
        translate([case_base_length - wall - 4.25, 4.25, head_z_offset])
            cylinder(10, d=screw_head);

        // screw hole with head sunk
        translate([case_base_length - wall - 4.25, pi0_width - 4.25, dongle_solder])
            cylinder(top_case_height, d=screw_thread + 0.2);
        translate([case_base_length - wall - 4.25, pi0_width - 4.25, head_z_offset])
            cylinder(10, d=screw_head);
    }
    translate([0, pi0_width / 2, dongle_solder - 1])
        top_clips();

}



bottom_case();
//top_case();
