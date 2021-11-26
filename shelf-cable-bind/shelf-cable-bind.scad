$fn=120;

hook_thickness = 3;
hook_inner_height = 10;
hook_max_depth = 8;

cable_binder_width = 8;
cable_binder_height = 3;
cable_binder_wall = 2;
cable_binder_x = cable_binder_width + 2 * cable_binder_wall;
cable_binder_y = hook_max_depth;
cable_binder_z = cable_binder_height + cable_binder_wall * 2;

_JOIN = 0.1;

module hook() {
    hook_radius = hook_max_depth / 2;
    cylinder(hook_thickness, hook_radius, hook_radius, center=true);
    translate([hook_inner_height / 2, 0, 0]) cube([hook_inner_height, hook_max_depth, hook_thickness], center=true);
    translate([hook_inner_height, 0, 0]) cylinder(hook_thickness, hook_radius, hook_radius, center=true);
    y = hook_max_depth / 2 + hook_thickness;
    translate([hook_inner_height, y / 2, 0]) cube([hook_max_depth, y + _JOIN, hook_thickness], center=true);
}



module cable_binder_tunnel() {

    difference() {
        cube([cable_binder_x, cable_binder_y, cable_binder_z], center=true);
        cube([cable_binder_width, cable_binder_y + 2, cable_binder_height], center=true);
    }
}

module all() {
    cube([cable_binder_x, hook_max_depth * 2.5, hook_thickness], center=true);

    dy_cable = 0;//hook_max_depth * 1.25 - cable_binder_y / 2;
    dz_cable = (cable_binder_z + hook_thickness) / 2 - cable_binder_wall;
    translate([0, -dy_cable, dz_cable]) cable_binder_tunnel();

    dx_hook = hook_inner_height;
    dy_hook = hook_max_depth / 2 + hook_thickness;
    dz_rotated_hook = hook_thickness / 2;
    dy_rotated_hook = hook_max_depth - hook_max_depth / 4 ;
    translate([0, dy_rotated_hook, -dz_rotated_hook]) rotate([90, 0, 90]) translate([-dx_hook, -dy_hook, 0]) hook();
}


all();
