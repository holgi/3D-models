

qtpy_plate  = [18.0, 20.8, 1.6]; // from the adafruit website


module qtpy_model() {
    qtpy_offset = [1.975,  -9.6, -0.78]; // centering the model plate to [0,0,0]
    translate(qtpy_offset)
            import("5426 QT Py ESP32-S3.stl");
}


module _qtpy_mount() {
    intersection() {
        translate([-0.1, 21.2, 0])
        import("QTPy-Case-Bottom.stl");

        translate([0, 7.5, 0])
        cube([26, 16, 12], center=true);
    }
}


module qtpy_mount() {
    for (i=[0,1]) 
        mirror([0, i, 0])
            _qtpy_mount();
}


module qtpy_model_and_mount() {
    translate([0, 0, 2.3]) qtpy_model();
    qtpy_mount();
}