include<dimensions.scad>;


function _net(l) = l - screw_head_height;
function _steps(l) = _net(l) - (_net(l) % 2) ;
function available_screw_length(l) = min(_steps(l), screw_shaft_max_length) + screw_head_height;


module _screw_shaft(length=20, slack=0)  {
    translate([0, 0, -slack])
        cylinder(h=length + slack, d=screw_shaft_diameter + slack);
}

module _screw_head(height=screw_head_height, slack=0)  {
    translate([0, 0, -slack])
        cylinder(h=height + slack * 2, d=screw_head_diameter + slack);
}

module _screw_nut(height=screw_nut_height, slack=0)  {
    translate([0, 0, -slack])
        cylinder(h=height + slack * 2, d=screw_nut_diameter + slack, $fn=6);
}


module screw(length=20, head=screw_head_height, slack=0) {
    real_length = available_screw_length(length);
    head_offset = real_length - screw_head_height;
    _screw_shaft(real_length, slack=slack);
    translate([0, 0, head_offset])
        _screw_head(head, slack=slack);
}


module nut() {
    difference() {
        _screw_nut(slack=0);
        _screw_shaft(slack=screw_hole_slack);
    }
}


module screw_hole(length=20, head=screw_head_height, slack=screw_hole_slack) {
    screw(length=length, head=head, slack=slack);
}

module nut_hole(height=screw_nut_height, slack=screw_hole_slack) {
    z_offset = screw_nut_height - height;
    translate([0, 0, z_offset])
    _screw_nut(height=height, slack=slack);
}


module screw_and_nut_hole(length, slack=screw_hole_slack, center=false) {
    real_length = available_screw_length(length);
    z_offset = center ? real_length / 2 : 0;

    translate([0, 0, -z_offset]) {
        screw_hole(length, head=length, slack=slack);
        nut_hole(height=length, slack);
    }
}


module show_screw_and_nut_in_hole(length, slack=screw_hole_slack, center=false) {
    real_length = available_screw_length(length);
    z_offset = center ? real_length / 2 : 0;

    translate([0, 0, -z_offset]) {
        screw();
        nut();
        % screw_hole(length=length, slack=slack);
        % nut_hole(slack=slack);
    }
}


screw_and_nut_hole(20, center=true);
