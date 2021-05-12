/*

SPAX measurements

Use function `spax(size)` to get a vector with spax measurements

Indexes in the vector:

    0: thread size
    1: head diameter
    2: core diameter
    3: shank diameter
    4: head height
    5: thread pitch
    6: height max length


Mostly you'd want a hole for a screw: `spax_bore_hole(size, total_height=0)`
If total_height is set to 0, the height of the head will be used.

the available spax sizes are 2.5, 3, 3.5, 4, 4.5, 5, 6 and 7.

*/



THREAD_SIZE_TOLERANCE = 0.15;
HEAD_DIAMETER_TOLERANCE = 0.4;
CORE_DIAMETER_TOLERANCE = 0.25;
SHANK_DIAMETER_TOLERANCE = 0.1;
THRED_PITCH_TOLERANCE = 0.1;
HEAD_ANGLE = 90;


SPAX_25_THREAD_SIZE = 2.5;
SPAX_25_HEAD_DIAMETER = 5.1;
SPAX_25_CORE_DIAMETER = 1.7;
SPAX_25_SHANK_DIAMETER = 1.8;
SPAX_25_HEAD_HEIGHT = 1.6;
SPAX_25_THREAD_PITCH = 1.3;
SPAX_25_HEIGHT_MAX_LENGTH = 13 - 10;
SPAX_25_VECTOR = [
    SPAX_25_THREAD_SIZE,
    SPAX_25_HEAD_DIAMETER,
    SPAX_25_CORE_DIAMETER,
    SPAX_25_SHANK_DIAMETER,
    SPAX_25_HEAD_HEIGHT,
    SPAX_25_THREAD_PITCH,
    SPAX_25_HEIGHT_MAX_LENGTH
];


SPAX_30_THREAD_SIZE = 3;
SPAX_30_HEAD_DIAMETER = 6;
SPAX_30_CORE_DIAMETER = 3;
SPAX_30_SHANK_DIAMETER = 2.15;
SPAX_30_HEAD_HEIGHT = 1.8;
SPAX_30_THREAD_PITCH = 1.5;
SPAX_30_HEIGHT_MAX_LENGTH = 15.5 - 12.5;
SPAX_30_VECTOR = [
    SPAX_30_THREAD_SIZE,
    SPAX_30_HEAD_DIAMETER,
    SPAX_30_CORE_DIAMETER,
    SPAX_30_SHANK_DIAMETER,
    SPAX_30_HEAD_HEIGHT,
    SPAX_30_THREAD_PITCH,
    SPAX_30_HEIGHT_MAX_LENGTH
];


SPAX_35_THREAD_SIZE = 3.5;
SPAX_35_HEAD_DIAMETER = 7;
SPAX_35_CORE_DIAMETER = 2.2;
SPAX_35_SHANK_DIAMETER = 2.45;
SPAX_35_HEAD_HEIGHT = 2.1;
SPAX_35_THREAD_PITCH = 1.8;
SPAX_35_HEIGHT_MAX_LENGTH = 20.5 - 16;
SPAX_35_VECTOR = [
    SPAX_35_THREAD_SIZE,
    SPAX_35_HEAD_DIAMETER,
    SPAX_35_CORE_DIAMETER,
    SPAX_35_SHANK_DIAMETER,
    SPAX_35_HEAD_HEIGHT,
    SPAX_35_THREAD_PITCH,
    SPAX_35_HEIGHT_MAX_LENGTH
];


SPAX_40_THREAD_SIZE = 4;
SPAX_40_HEAD_DIAMETER = 8;
SPAX_40_CORE_DIAMETER = 2.5;
SPAX_40_SHANK_DIAMETER = 2.85;
SPAX_40_HEAD_HEIGHT = 2.4;
SPAX_40_THREAD_PITCH = 2;
SPAX_40_HEIGHT_MAX_LENGTH = 20.5 - 16;
SPAX_40_VECTOR = [
    SPAX_40_THREAD_SIZE,
    SPAX_40_HEAD_DIAMETER,
    SPAX_40_CORE_DIAMETER,
    SPAX_40_SHANK_DIAMETER,
    SPAX_40_HEAD_HEIGHT,
    SPAX_40_THREAD_PITCH,
    SPAX_40_HEIGHT_MAX_LENGTH
];


SPAX_45_THREAD_SIZE = 4.5;
SPAX_45_HEAD_DIAMETER = 8.8;
SPAX_45_CORE_DIAMETER = 2.8;
SPAX_45_SHANK_DIAMETER = 3.2;
SPAX_45_HEAD_HEIGHT = 2.7;
SPAX_45_THREAD_PITCH = 2.2;
SPAX_45_HEIGHT_MAX_LENGTH = 25.5 - 20;
SPAX_45_VECTOR = [
    SPAX_45_THREAD_SIZE,
    SPAX_45_HEAD_DIAMETER,
    SPAX_45_CORE_DIAMETER,
    SPAX_45_SHANK_DIAMETER,
    SPAX_45_HEAD_HEIGHT,
    SPAX_45_THREAD_PITCH,
    SPAX_45_HEIGHT_MAX_LENGTH
];


SPAX_50_THREAD_SIZE = 5;
SPAX_50_HEAD_DIAMETER = 9.7;
SPAX_50_CORE_DIAMETER = 3.1;
SPAX_50_SHANK_DIAMETER = 3.55;
SPAX_50_HEAD_HEIGHT = 2.9;
SPAX_50_THREAD_PITCH = 2.5;
SPAX_50_HEIGHT_MAX_LENGTH = 36 - 25;
SPAX_50_VECTOR = [
    SPAX_50_THREAD_SIZE,
    SPAX_50_HEAD_DIAMETER,
    SPAX_50_CORE_DIAMETER,
    SPAX_50_SHANK_DIAMETER,
    SPAX_50_HEAD_HEIGHT,
    SPAX_50_THREAD_PITCH,
    SPAX_50_HEIGHT_MAX_LENGTH
];


SPAX_60_THREAD_SIZE = 6;
SPAX_60_HEAD_DIAMETER = 11.3;
SPAX_60_CORE_DIAMETER = 3.8;
SPAX_60_SHANK_DIAMETER = 4.3;
SPAX_60_HEAD_HEIGHT = 3.4;
SPAX_60_THREAD_PITCH = 3.0;
SPAX_60_HEIGHT_MAX_LENGTH = 30.5 - 24;
SPAX_60_VECTOR = [
    SPAX_60_THREAD_SIZE,
    SPAX_60_HEAD_DIAMETER,
    SPAX_60_CORE_DIAMETER,
    SPAX_60_SHANK_DIAMETER,
    SPAX_60_HEAD_HEIGHT,
    SPAX_60_THREAD_PITCH,
    SPAX_60_HEIGHT_MAX_LENGTH
];


SPAX_70_THREAD_SIZE = 7;
SPAX_70_HEAD_DIAMETER = 13.1;
SPAX_70_CORE_DIAMETER = 4.5;
SPAX_70_SHANK_DIAMETER = 4.9;
SPAX_70_HEAD_HEIGHT = 3.8;
SPAX_70_THREAD_PITCH = 3.5;
SPAX_70_HEIGHT_MAX_LENGTH = 41 - 33;
SPAX_70_VECTOR = [
    SPAX_70_THREAD_SIZE,
    SPAX_70_HEAD_DIAMETER,
    SPAX_70_CORE_DIAMETER,
    SPAX_70_SHANK_DIAMETER,
    SPAX_70_HEAD_HEIGHT,
    SPAX_70_THREAD_PITCH,
    SPAX_70_HEIGHT_MAX_LENGTH
];


SPAX_VECTORS = [
    SPAX_25_VECTOR,
    SPAX_30_VECTOR,
    SPAX_35_VECTOR,
    SPAX_40_VECTOR,
    SPAX_45_VECTOR,
    SPAX_50_VECTOR,
    SPAX_60_VECTOR,
    SPAX_70_VECTOR
];

SPAX_SIZES = [2.5, 3, 3.5, 4, 4.5, 5, 6, 7];


function _spax_index(size) = search(size, SPAX_SIZES)[0];
function spax(size) = SPAX_VECTORS[_spax_index(size)];

function spax_max_head_diameter(size) =
    let(screw = spax(size))
    screw[1] + HEAD_DIAMETER_TOLERANCE;

function spax_max_shank_diameter(size) =
    let(screw = spax(size))
    screw[3] + SHANK_DIAMETER_TOLERANCE;

function spax_max_head_height(size) =
    let(
        screw = spax(size),
        head_diameter = spax_max_head_diameter(size),
        shank_diameter = spax_max_shank_diameter(size)
    )
    (head_diameter - shank_diameter) / 2;


module spax_bore_hole(size, total_height=0) {
    shank_diameter = spax_max_shank_diameter(size);
    head_diameter = spax_max_head_diameter(size);
    head_height = spax_max_head_height(size);
    shank_height = max(head_height,  total_height);
    cylinder(head_height, d1=head_diameter, d2=shank_diameter, $fn=120);
    cylinder(shank_height, d=shank_diameter, $fn=120);
}

