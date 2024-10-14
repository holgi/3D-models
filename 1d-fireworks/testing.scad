include <dimensions.scad>


use <WAGO_221_mount.scad>
// wago_mount([5,2]);


module test_usb_c_holes() {

    wall = 2;

    tight = [13.5, 9, 5.3];
    between = 10;

    function diff(n) = (n * (tight.z + between) + between/2);

    translate([0, 0, 2])
        rotate([-90, 0, 0])
            difference() {
                cube([tight.x * 2, 2, 80]);

                translate([tight.x/2, -1, diff(0)])
                    cube(tight);

                translate([tight.x/2, -1, diff(1)])
                    cube(tight + [0.25, 0.25, 0.25]);

                translate([tight.x/2, -1, diff(2)])
                    cube(tight + [0.5, 0.5, 0.5]);

                translate([tight.x/2, -1, diff(3)])
                    cube(tight + [0.75, 0.75, 0.75]);

                translate([tight.x/2, -1, diff(4)])
                    cube(tight + [1, 1, 1]);
            }

    translate([0, 0, 0])
        rotate([90, 0, 0])
            difference() {
                cube([tight.x * 2, 1, 80]);

                translate([tight.x/2, -1, diff(0)])
                    cube(tight);

                translate([tight.x/2, -1, diff(1)])
                    cube(tight + [0.25, 0.25, 0.25]);

                translate([tight.x/2, -1, diff(2)])
                    cube(tight + [0.5, 0.5, 0.5]);

                translate([tight.x/2, -1, diff(3)])
                    cube(tight + [0.75, 0.75, 0.75]);

                translate([tight.x/2, -1, diff(4)])
                    cube(tight + [1, 1, 1]);
            }
}
// test_usb_c_holes();



translate([0, 0, 0]) esp32_model();
