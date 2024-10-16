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
/*
use <qtpy.scad>
translate([0, 0, 2])
    qtpy_mount();
cube([35, 35, 4], center=true);
*/
difference() {
    for (d=[-1,0,1]) {
        h = 5;
        off = d*h;
        delta = 0.25*d;
        dia =spool_case_diameter + delta;
        echo(dia)
        translate([0,0,off])
            cylinder(h=h, d=dia);
    }
    translate([0,0,-50])
        cylinder(h=100, d=spool_case_diameter - 20);
}
