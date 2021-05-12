$fn=60;

// dimensions of the jst plug
jst_length_total = 13.3;
jst_length_back = 5;
jst_length_front = jst_length_total - jst_length_back;

jst_height_front = 3;
jst_height_back = 3.3;

jst_width = 5.3;
bottom_cut = 1.5;
jst_bottom_width = jst_width - bottom_cut;

jst_grove_width = 0.6;
jst_grove_height = 0.4;

cable_width = 2.25;
cable_distance = 0.7;

// dimensions related to the socket
socket_top_height = 1;
socket_bottom_height = 1.5;
socket_total_height = socket_bottom_height + jst_height_back + socket_top_height;

socket_back_length = 3;
socket_back_width_addition = 1;

socket_back_width = jst_width + socket_back_width_addition * 2;

//top_rail_width = 1;
//top_rail_height = 0.5;

//top_rail_plug_length = 3;

// constant for joining things together
JOIN = 0.001;


module cable_break () {
    cable_offset_y = socket_back_width / 2;
    cable_offset_z = socket_total_height / 2;
    translate([-1, cable_offset_y, cable_offset_z]) rotate([0,  90, 0]) cylinder(socket_back_length + 2, d=cable_width);
}

module back() {
    cable_offset = (cable_width + cable_distance) / 2;
    difference() {
        cube([socket_back_length, socket_back_width, socket_total_height]);
        translate([0, cable_offset, 0]) cable_break();
        translate([0, -cable_offset, 0]) cable_break();
    }
}

module grove() {
    x_offset = jst_length_front / 2;
    y_offset = jst_grove_width / 1.41;
    translate([x_offset, y_offset, 0])
        rotate([45, 0, 0])
            cube([jst_length_front, jst_grove_width, jst_grove_width], center=true);
}

module bottom() {
    jst_height_delta = jst_height_back - jst_height_front;
    bottom_back_height = socket_bottom_height - jst_height_delta;
    grove_offset_y = (jst_width - jst_grove_width) / 2;

    cube([jst_length_back + JOIN, jst_width, bottom_back_height]);
    translate([jst_length_back, 0, 0]) {
        cube([jst_length_front, jst_bottom_width, socket_bottom_height]);
        translate([0, grove_offset_y, socket_bottom_height - JOIN]) grove();
    }

}

module top() {
    cube([jst_length_back, jst_width, socket_top_height]);
}

module assembly() {
    bottom();
    translate([JOIN - socket_back_length, -socket_back_width_addition, 0]) back();
    translate([0, 0, socket_total_height - socket_top_height]) top();
}

assembly();
//grove();
