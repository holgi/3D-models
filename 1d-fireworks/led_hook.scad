include<box.scad>;
include<dimensions.scad>;
include<led_strip.scad>;
include<screw.scad>;
include<wire_clutch.scad>;



hook_box_inner_width  = led_strip_end_width + 2 * wall_width + 2 * screw_nut_diameter;
hook_box_inner_length = led_strip_end_length + led_strip_clutch_length + wire_length / 2;

hook_box_outer_width  = led_strip_end_width + screw_pillar_diameter * 2;
hook_box_outer_length = hook_box_inner_length + 2 * wall_width;
hook_box_outer_height = hook_box_inner_height + 2 * wall_width;

hook_box_outer      = [hook_box_outer_width, hook_box_outer_length, hook_box_outer_height];
hook_box_lower_part = [hook_box_outer_width, hook_box_outer_length, wall_width + led_strip_clutch_height];
hook_box_upper_part = [hook_box_outer_width, hook_box_outer_length, hook_box_outer_height - hook_box_lower_part.z];


clutch_width   = led_strip_end_width + screw_pillar_radius;

ridge_length   = hook_box_inner_length - screw_pillar_diameter * 2;
ridge_offset   = (hook_box_outer_width - wall_width) / 2;
ridge_diameter = wall_width / 2;

hook_width = (hook_outer_diameter - hook_inner_diameter) / 2;
hook_offset = (hook_box_outer_length + hook_outer_diameter - hook_width) / 2 ;




module hook(outer=hook_outer_diameter, inner=hook_inner_diameter, height=wall_width) {
    width = (outer - inner) / 2;
    difference() {
        cylinder(h = height, d=outer);
        translate([0, 0, -1])
            cylinder(h=height + 2, d=inner);
        translate([-outer, -outer, -1])
            cube([outer, outer, height + 2]);
    }
    delta = (outer - width) / 2;
    translate([-delta , 0, 0])
        cylinder(h=height, d=width);

    translate([0, -delta, 0])
        cylinder(h=height, d=width);
}

module case_lower() {

    difference(){
        union() {
            // basic case
            case(hook_box_lower_part, radius=screw_pillar_radius, inset=wall_width, sphere_diameter=screw_nut_diameter, lower=true);

            // led strip clutch area
            translate([-clutch_width / 2, -hook_box_lower_part.y / 2, box_z_radius])
                cube([clutch_width, led_strip_clutch_length, hook_box_lower_part.z - box_z_radius]);

        }
        // led strip cutout
        translate([0, -hook_box_lower_part.y / 2, wall_width])
            _clutch_zone(slack=1);
    }

    inner_clutch_edge = hook_box_inner_width / 2 - 1;
    outer_clutch_edge = wire_clutch_width / 2 + wall_width;
    center_offset     = inner_clutch_edge + (outer_clutch_edge - inner_clutch_edge) / 2;

    translate([-center_offset, wire_clutch_assembly_offset / 2, wall_width])
        clutch_clamp();
    translate([+center_offset, wire_clutch_assembly_offset / 2, wall_width])
        clutch_clamp();

    translate([0, hook_offset, 0])
        hook();

}


module case_upper() {

    difference(){
        union() {
            // basic case
            case(hook_box_upper_part, radius=screw_pillar_radius, inset=wall_width, sphere_diameter=screw_nut_diameter, lower=false);

            // led strip clutch area
            translate([-clutch_width / 2, -hook_box_lower_part.y / 2, box_z_radius])
                cube([clutch_width, led_strip_clutch_length, hook_box_upper_part.z - box_z_radius]);
        }
    }

    fix_wire_clutch_length = hook_box_upper_part.y / 2 - screw_pillar_diameter + wall_width - wire_clutch_assembly_offset;
    for (i=[0,1]) {
        mirror([i, 0, 0]) {
            difference() {
                translate([-hook_box_upper_part.x / 2, wire_clutch_assembly_offset, box_z_radius])
                    cube([hook_box_upper_part.x / 4 + 1, fix_wire_clutch_length, hook_box_upper_part.z - box_z_radius]);

                translate([-hook_box_upper_part.x / 4, wire_clutch_assembly_offset + 1, hook_box_upper_part.z / 2 + 1])
                    rotate([0, 0, -90])
                        rounded_edge(hook_box_upper_part.z + 2, 2);
            }
        }
    }

}


// Assembly

translate([50, 0, 0]) case_upper();

translate([0, 0, -wall_width]) case_lower();

translate([0, wire_clutch_assembly_offset, 0]) color("DarkOrange", 0.5) wire_clutch();

translate([0, -hook_box_outer.y / 2 , 0]) color("LightCyan", 0.5) led_strip();




