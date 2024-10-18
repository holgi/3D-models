include <dimensions.scad>


qtpy_plate  = [18.0, 20.8, 1.6]; // from the adafruit website

qtpy_radius = 2.5; // mm
qtpy_usb_width = 9.0; // mm
qtpy_usb_distance = (qtpy_plate.y - qtpy_usb_width) / 2;
qtpy_usb_offset   = 1.0; // mm
qtpy_ground_offset = 2.0; // mm

qtpy_side_clip_riser = [2, 5, 4]; // mm
qtpy_side_clip_diameter = 3.0; // mm

slack=0.1;

module qtpy_model() {
    qtpy_offset = [1.975,  -9.6, -0.78]; // centering the model plate to [0,0,0]
    translate(qtpy_offset)
            import("5426 QT Py ESP32-S3.stl");
}




module qtpy_corner_stand() {
    difference() {
        translate([-1, -1, -slack])
        cylinder(h=qtpy_ground_offset + qtpy_plate.z + slack, d1=7.5, d2=5);

        translate([0, 0, qtpy_ground_offset])
            minkowski() {
                cube(qtpy_plate - [qtpy_radius, qtpy_radius, 0]);
                cylinder(h=qtpy_plate.z + 2, r=qtpy_radius + slack);

            }
    }
}

module qtpy_four_corner_stands() {
    half = qtpy_plate / 2;
    move_by = [qtpy_radius, qtpy_radius, 0] - [half.x, half.y, 0] - [slack, slack, 0];
    copy_mirror([0,1,0])
        copy_mirror([1,0,0])
            translate(move_by)
                qtpy_corner_stand();
}



module qtpy_side_clips() {

    translate([qtpy_plate.x / 2 + slack, -qtpy_side_clip_riser.y / 2, -slack])
        cube(qtpy_side_clip_riser);

    translate([qtpy_plate.x / 2 + qtpy_side_clip_riser.x / 2 + slack, -qtpy_side_clip_riser.y / 2, 4.6])
        rotate([-90, 0, 0])
            cylinder(h=qtpy_side_clip_riser.y, d=qtpy_side_clip_diameter);

}


module qtpy_mount(base_height = slack) {

    difference () {
        qtpy_four_corner_stands();
        cube([13, 30, 10], center=true);
    }

    copy_mirror([1,0,0])
        qtpy_side_clips();

    translate([0, 0, -base_height / 2])
        cube([30, 30, base_height], center=true);
}


qtpy_mount(4);

translate([0 , 0,qtpy_ground_offset + qtpy_plate.z / 2]) qtpy_model();
