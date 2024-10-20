include<dimensions.scad>;

spool_distance = 62.5; // mm


m4_screw = 4; // mm
m4_screw_hole = 3.75; // mm
m4_screw_length = 15; // mm

wall = 2; // mm

pole_diameter = m4_screw_hole + 2 * wall;

difference() {
cylinder(h=spool_distance, d=pole_diameter, center=true, $fn=6);
translate([0, 0, (+spool_distance - m4_screw_length) / 2])
    cylinder(h=m4_screw_length + 1, d=m4_screw_hole, center=true);
translate([0, 0, (-spool_distance + m4_screw_length) / 2])
    cylinder(h=m4_screw_length + 1, d=m4_screw_hole, center=true);

}
