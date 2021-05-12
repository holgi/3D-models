use <threadlib/threadlib.scad>

// constants
$fn = 120;

SHAFT_MIN_WALL = 2;
CONE_MIN_WALL = 0.5;
CONE_SLOPE = 15;
CONE_CUT = 1;

LEEWAY = 0.1;

// thread table
// [thread support diameter, thread designator]
THREAD_TABLE = [
    [0.6620, "M1"],
    [1.4780, "M2"],
    [2.3555, "M3"],
    [3.1110, "M4"],
    [3.9895, "M5"],
    [4.7435, "M6"],
    [5.7435, "M7"],
    [6.4455, "M8"],
    [7.4455, "M9x1.25"],
    [8.1410, "M10"],
    [9.8365, "M12"],
    [11.5340, "M14"],
    [13.5340, "M16"],
    [14.9380, "M18"],
    [16.9380, "M20"],
    [18.9380, "M22"],
    [20.3295, "M24"],
    [23.3295, "M27"],
    [25.7320, "M30"],
    [28.7530, "M33"],
    [31.1320, "M36"],
    [34.1320, "M39"],
    [36.5360, "M42"],
    [39.5360, "M45"],
    [41.9335, "M48"],
    [45.9405, "M52"],
    [49.3355, "M56"],
    [53.3355, "M60"]
];

function thread_designator(min_diameter) = [for (n=THREAD_TABLE) if (n[0]>min_diameter) n][0][1];

function hex_from_diameter(diameter) = diameter * 2 / sqrt(3);


// calculation of fitting cone stuff, mostly for sleeve module
function fitting_cone_start_radius(designator) = thread_specs(str(designator, "-ext"))[2] / 2;
function fitting_cone_end_radius(shaft_diameter, wall_min) = (shaft_diameter / 2) + wall_min;
function fitting_cone_height(designator, shaft_diameter, wall_min, slope) = (fitting_cone_start_radius(designator) - fitting_cone_end_radius(shaft_diameter, wall_min)) / tan(slope);


module metric_hex_nut(height, outer_diameter, inner_diameter=0) {
    hex_diameter = hex_from_diameter(ceil(outer_diameter));
    //echo(ceil(outer_diameter));
    difference() {
        cylinder(height, d=hex_diameter, $fn=6);
        if (inner_diameter > 0) {
            translate([0, 0, -LEEWAY]) cylinder(height + LEEWAY, d=inner_diameter);
        }
    }
}

module fitting(shaft_diameter, turns=3, higbee_arc=30, shaft_wall=SHAFT_MIN_WALL, slope=CONE_SLOPE, wall_min=CONE_MIN_WALL, cut=CONE_CUT) {
    // get a fitting thread designator
    min_shaft_diameter = shaft_diameter + (shaft_wall * 2);
    designator = thread_designator(min_shaft_diameter);

    // thread specific calculation, lended from threadlib
    specs = thread_specs(str(designator, "-ext"));
    P = specs[0];  // turn offset
    H = (turns + 1) * P;  // height in total

    // cone calculations
    cone_start_radius = fitting_cone_start_radius(designator);
    cone_end_radius = fitting_cone_end_radius(shaft_diameter, wall_min);
    cone_height = fitting_cone_height(designator, shaft_diameter, wall_min, slope);

    complete_height = H + cone_height;

    difference() {
        union() {
            translate([0, 0, P / 2]) bolt(designator, turns, higbee_arc);
            translate([0, 0, H - LEEWAY]) cylinder(cone_height, cone_start_radius, cone_end_radius);
        }
        translate([0, 0, -LEEWAY]) cylinder(complete_height + 2 * LEEWAY, d=(shaft_diameter + 2 * LEEWAY));
        translate([0, 0, H + cone_height / 2]) cube([cone_start_radius + 2 * LEEWAY, cut, cone_height + LEEWAY], center=true);
    }
}


module sleeve(shaft_diameter, turns=3, higbee_arc=30, shaft_wall=SHAFT_MIN_WALL, slope=CONE_SLOPE, wall_min=CONE_MIN_WALL, cut=CONE_CUT) {
    // get a fitting thread designator
    min_shaft_diameter = shaft_diameter + (shaft_wall * 2);
    designator = thread_designator(min_shaft_diameter);

    // thread specific calculation, lended from threadlib
    specs = thread_specs(str(designator, "-int"));
    P = specs[0];  // turn offset
    H = (turns + 1) * P;  // height in total
    Dsupport = specs[2];  // thread support diameter
    Douter = Dsupport + 2 * shaft_wall;

    // cone calculations
    cone_start_radius = Dsupport / 2;
    cone_end_radius = (shaft_diameter / 2);
    cone_height = fitting_cone_height(designator, shaft_diameter, wall_min, slope);

    complete_height = H + cone_height + shaft_wall;

    difference() {
        union() {
            translate([0, 0, P / 2]) nut(designator, turns, Douter=Douter);
            translate([0, 0, H  - LEEWAY]) cylinder(cone_height + shaft_wall + LEEWAY, d=Douter);
            metric_hex_nut(H, Douter, Dsupport);
        }
        // cone
        translate([0, 0, H - LEEWAY * 2]) cylinder(cone_height, cone_start_radius, cone_end_radius);
        // shaft
        translate([0, 0, -LEEWAY]) cylinder(complete_height + 2 * LEEWAY, d=(shaft_diameter + 2 * LEEWAY));
    }
}



diameter = 20;
difference() {
    sleeve(diameter);
    translate([0,0,-1]) cube([20, 20, 50]);
}
#translate([0, 0, 0]) fitting(diameter);
//translate([0, 0, -10]) cylinder(50, d=diameter);
