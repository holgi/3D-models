include<dimensions.scad>;


module led_strip_clutch_zone(slack=0) {
    translate([-led_strip_width / 2, -slack, 0])
        cube([led_strip_width,  led_strip_clutch_length + 2 * slack, led_strip_clutch_height + slack]);
}

module led_strip(length=led_wire_length) {

    wire_radius = led_wire_diameter / 2;

    module _ribbon_cable(length, number=5) {
        zero_index = number - 1;
        factors = [ for( i=[0:zero_index] ) i - zero_index / 2 ];

        translate([0, 0, wire_radius])
            rotate([-90, 0, 0])
                for(i=factors) {
                    dx = i * led_wire_diameter;
                    translate([dx, 0, 0])
                        cylinder(h=length, d=led_wire_diameter);
                }
    }

    module _led_strip_wires(length) {
        _ribbon_cable(length=length, number=5);
        hull() {
            translate([0, 0, led_wire_diameter])
                _ribbon_cable(length=1, number=2);
            _ribbon_cable(length=led_wire_sort_distance, number=5);
        }
    }

    // this is the anchor to build around
    // the clutch zone for the strip
    led_strip_clutch_zone();

    // the end cab of the strip
    translate([-led_strip_end_width / 2, led_strip_clutch_length, 0])
        cube([led_strip_end_width, led_strip_end_length, led_strip_end_height]);

    // the wires
    translate([0, led_strip_end_length + led_strip_clutch_length, 0])
        _led_strip_wires(length=length / 2);

    // the rest of the strip
    translate([-led_strip_width / 2, -length, 0])
        cube([led_strip_width, length, led_strip_height]);

}


color("LightBlue", 0.5) led_strip();