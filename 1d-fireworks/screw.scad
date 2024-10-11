include<dimensions.scad>;


module _shaft(length=20, slack=0)  {
    translate([0, 0, -slack])
        cylinder(h=length + slack, d=screw_shaft_diameter + slack);
}

module _head(height=screw_head_height, slack=0)  {
    translate([0, 0, -slack])
        cylinder(h=height + slack * 2, d=screw_head_diameter + slack);
}

module _nut(height=screw_nut_height, slack=0)  {
    translate([0, 0, -slack])
        cylinder(h=height + slack * 2, d=screw_nut_diameter + slack, $fn=6);
}


module screw(length=20, head=screw_head_height, slack=0) {
    head_offset = length - screw_head_height;
    _shaft(length, slack=slack);
    translate([0, 0, head_offset])
        _head(head, slack=slack);
}


module nut() {
    difference() {
        _nut(slack=0);
        _shaft(slack=screw_hole_slack);
    }
}


module screw_hole(length=20, head=screw_head_height, slack=screw_hole_slack) {
    screw(length=length, head=head, slack=slack);
}

module nut_hole(height=screw_nut_height, slack=screw_hole_slack) {
    z_offset = screw_nut_height - height;
    translate([0, 0, z_offset])
    _nut(height=height, slack=slack);
}


module screw_and_nut_hole(length, slack=screw_hole_slack, center=false) {
    z_offset = center ? length / 2 : 0;
    
    translate([0, 0, -z_offset]) {
        screw_hole(length, head=length, slack=slack);
        nut_hole(height=length, slack);
    }
}


module show_screw_and_nut_in_hole(length, slack=screw_hole_slack, center=false) {
    z_offset = center ? length / 2 : 0;
    
    translate([0, 0, -z_offset]) {
        screw();
        nut();
        % screw_hole(length=length, slack=slack);
        % nut_hole(slack=slack);
    }
}


screw_and_nut_hole(20, center=true);