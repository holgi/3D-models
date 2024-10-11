include<dimensions.scad>;



module _screw(length, slack=0)  {

    translate([0, 0, -slack])
        cylinder(h=length + slack, d=screw_shaft_diameter + slack);

    head_offset = length - screw_head_height;
    translate([0, 0, head_offset])
        cylinder(h=screw_head_height + slack, d=screw_head_diameter + slack);
}

module screw(length=20) {
    _screw(length, slack=0);
}

module screw_hole(length=20, slack=screw_hole_slack) {
    _screw(length, slack);
}


module _nut_base(slack=0)  {
    translate([0, 0, -slack])
        cylinder(h=screw_nut_height + slack * 2, d=screw_nut_diameter + slack, $fn=6);
}

module nut() {
    difference() {
        _nut_base(slack=0);
        screw_hole();
    }
}

module nut_hole(slack=screw_hole_slack) {
    _nut_base(slack=slack);
}


module screw_and_nut_hole(length, slack=screw_hole_slack) {
    screw_hole(length, slack);
    nut_hole(slack);
}


