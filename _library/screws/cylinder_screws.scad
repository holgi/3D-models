/* Dimensions for Cylinder Screws with Hex head (DIN 912, ISO 4762)

please use function cylinder_screw() to retrieve the basic dimensions.

Example

result = get_screw("M3");

result == [
    "M3",   // name
    3,      // shaft diameter
    5.5,    // head diameter
    3       // head height
];
*/

$fn = 120;

METRIC_CYLINDER_SCREWS = [
    [ "M1.4", 1.4, 2.6, 1.4],
    [ "M1.6", 1.6, 3,   1.6],
    [ "M2",   2,   3.8, 2],
    [ "M2.5", 2.5, 4.5, 2.5],
    [ "M3",   3,   5.5, 3],
    [ "M4",   4,   7,   4],
    [ "M5",   5,   8.5, 5],
    [ "M6",   6,  10,   6],
    [ "M8",   8,  13,   8],
    ["M10",  10,  16,  10],
    ["M12",  12,  18,  12],
    ["M14",  14,  21,  14],
    ["M16",  16,  24,  16],
    ["M18",  18,  27,  18],
    ["M20",  20,  30,  20],
    ["M22",  22,  33,  22],
    ["M24",  24,  36,  24],
    ["M27",  27,  40,  27],
    ["M30",  30,  45,  30],
    ["M33",  33,  50,  33],
    ["M36",  36,  54,  36],
    ["M39",  39,  58,  39],
    ["M42",  42,  63,  42],
    ["M45",  45,  68,  45],
    ["M52",  52,  78,  52],
    ["M56",  56,  84,  56],
    ["M64",  64,  96,  64],
    ["M72",  72, 108,  72],
];

function _get_cylinder_screw_index(which) = search([which], METRIC_CYLINDER_SCREWS, index_col_num=1);
function cylinder_screw(which) = METRIC_CYLINDER_SCREWS[_get_cylinder_screw_index(which)[0]];


module cylinder_screw_bore_hole(size, length, head=true, slack=0, elongate_head=1) {
    /* generates a form for a cylinder screw bore hole

    The screw will be centered on x and y axis. On the z-axis it is centered
    according to the length of the screw, so excluding the elongated head
    as specified by parameter.

    size:           screw size like "M3"
    length:         length of the screw, including head
    head:           include screw head
    slack:          add this size to the hole diameters (shaft and head)
    elongate_head:  add this extra length to the head
    */
    dimensions = cylinder_screw(size);
    shaft_diameter = dimensions[1];
    head_diameter = dimensions[2];
    head_length = min(length, dimensions[3]);
    head_z_offset = (length - head_length + elongate_head) / 2;

    cylinder(length, d=shaft_diameter + slack, center=true);
    if (head) {
        translate([0, 0, head_z_offset])
            cylinder(head_length + elongate_head, d=head_diameter + slack, center=true);
    }
}


cylinder_screw_bore_hole("M3" ,20, head=true);
