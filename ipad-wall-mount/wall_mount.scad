
$fn = 60;

m3_shaft     = 3.0;  // mm
m3_head      = 6.0;  // mm
screw_offset = 2.5;  // mm

sink_offset = m3_shaft / 2 - 0.9;


module import_corner() {
    translate([0, -10, 5.75])
    import("iPad_Mount_Corner.stl");
}


module import_edge() {
    translate([0, -10, 5.75])
    import("iPad_Mount_Edge.stl");
}


module screw_head() {
    translate([0, 0, sink_offset])
    cylinder(h=m3_shaft, d1=m3_shaft, d2=m3_head, center=true);
}


module edge() {
    difference() {
        import_edge();
        translate([0, screw_offset, 0])
            screw_head();
    }
}


module corner() {
    difference() {
        import_corner();
        translate([-screw_offset, screw_offset, 0])
            screw_head();
    }
}

translate([+20, 0, 0]) edge();
translate([-20, 0, 0]) corner();
