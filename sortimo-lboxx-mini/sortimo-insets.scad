$fn = 30;

/* CONSTANTS */

/* Basic adjustable constants */

OUTER_WALLS        =  1.6;
INNER_WALLS        =  0.8;
FLOOR              =  1.2;
LOWER_PART_HEIGHT  = 22.0;  // half of full height


/* Dimensions of the volumetric model */

FULL_BASE_X  = 239.2484580011245;  // extracted from dxf file
FULL_BASE_Y  = 149.9482445970158;  // extracted from dxf file
FULL_BASE_Z  =  44;
INSET_HEIGHT =   6;
INSET_DEPTH  =   4;


/* How to cut the three modules */

MODULE_CUT_DISTANCE = 77.4;  // mm
MODULE_CUT_LEEWAY   =  0.3;  // mm


/* Dimensions of the connector for original separators */

CONNECTOR_INNER_LENGHT  = 4; //mm
CONNECTOR_INNER_WIDTH   = 6; //mm
CONNECTOR_OPENING_LOWER = 2; //mm
CONNECTOR_OPENING_UPPER = 3; //mm


/* Part names as constants */

PART_FULL  = "full";
PART_LOWER = "lower";
PART_UPPER = "upper";


/* CALCULATED VALUES */


/* Where to cut the three modules */

_MODULE_CUT_X = MODULE_CUT_DISTANCE / 2;

MODULE_CUT_X_INNER = _MODULE_CUT_X - MODULE_CUT_LEEWAY;
MODULE_CUT_X_OUTER = _MODULE_CUT_X + MODULE_CUT_LEEWAY;


/* Calculations for well sizes */

_HALF_BASE_X = FULL_BASE_X / 2;
_HALF_BASE_Y = FULL_BASE_Y / 2;

_MODULE_OUTER_CENTER_X = _MODULE_CUT_X + (_HALF_BASE_X - _MODULE_CUT_X) / 2 + OUTER_WALLS;
_MODULE_OUTER_CENTER_Y = (_HALF_BASE_Y - OUTER_WALLS - INNER_WALLS / 2) / 2;

_WELL_1_X = 0 + INNER_WALLS  / 2;
_WELL_2_X = MODULE_CUT_X_INNER - OUTER_WALLS;
_WELL_3_X = MODULE_CUT_X_OUTER + OUTER_WALLS;
_WELL_4_X = _MODULE_OUTER_CENTER_X - INNER_WALLS / 2;
_WELL_5_X = _MODULE_OUTER_CENTER_X + INNER_WALLS / 2;
_WELL_6_X = _HALF_BASE_X - OUTER_WALLS;

_WELL_1_Y = 0 + INNER_WALLS  / 2;
_WELL_2_Y = _MODULE_OUTER_CENTER_Y - INNER_WALLS / 2;
_WELL_3_Y = _MODULE_OUTER_CENTER_Y + INNER_WALLS / 2;
_WELL_4_Y = _HALF_BASE_Y - OUTER_WALLS;


/* Definition of well locations

WELL_NAME = [ upper left point, lower right point]
*/

WELL_LEFT_1   = [ [-_WELL_5_X, +_WELL_4_Y], [-_WELL_6_X, +_WELL_3_Y] ];
WELL_LEFT_2   = [ [-_WELL_3_X, +_WELL_4_Y], [-_WELL_4_X, +_WELL_3_Y] ];
WELL_LEFT_3   = [ [-_WELL_5_X, +_WELL_2_Y], [-_WELL_6_X, +_WELL_1_Y] ];
WELL_LEFT_4   = [ [-_WELL_3_X, +_WELL_2_Y], [-_WELL_4_X, +_WELL_1_Y] ];
WELL_LEFT_5   = [ [-_WELL_5_X, -_WELL_2_Y], [-_WELL_6_X, -_WELL_1_Y] ];
WELL_LEFT_6   = [ [-_WELL_3_X, -_WELL_2_Y], [-_WELL_4_X, -_WELL_1_Y] ];
WELL_LEFT_7   = [ [-_WELL_5_X, -_WELL_4_Y], [-_WELL_6_X, -_WELL_3_Y] ];
WELL_LEFT_8   = [ [-_WELL_3_X, -_WELL_4_Y], [-_WELL_4_X, -_WELL_3_Y] ];

WELL_MIDDLE_1 = [ [-_WELL_1_X, +_WELL_4_Y], [-_WELL_2_X, +_WELL_3_Y] ];
WELL_MIDDLE_2 = [ [+_WELL_1_X, +_WELL_4_Y], [+_WELL_2_X, +_WELL_3_Y] ];
WELL_MIDDLE_3 = [ [-_WELL_1_X, +_WELL_2_Y], [-_WELL_2_X, +_WELL_1_Y] ];
WELL_MIDDLE_4 = [ [+_WELL_1_X, +_WELL_2_Y], [+_WELL_2_X, +_WELL_1_Y] ];
WELL_MIDDLE_5 = [ [-_WELL_1_X, -_WELL_2_Y], [-_WELL_2_X, -_WELL_1_Y] ];
WELL_MIDDLE_6 = [ [+_WELL_1_X, -_WELL_2_Y], [+_WELL_2_X, -_WELL_1_Y] ];
WELL_MIDDLE_7 = [ [-_WELL_1_X, -_WELL_4_Y], [-_WELL_2_X, -_WELL_3_Y] ];
WELL_MIDDLE_8 = [ [+_WELL_1_X, -_WELL_4_Y], [+_WELL_2_X, -_WELL_3_Y] ];

WELL_RIGHT_1  = [ [+_WELL_3_X, +_WELL_4_Y], [+_WELL_4_X, +_WELL_3_Y] ];
WELL_RIGHT_2  = [ [+_WELL_5_X, +_WELL_4_Y], [+_WELL_6_X, +_WELL_3_Y] ];
WELL_RIGHT_3  = [ [+_WELL_3_X, +_WELL_2_Y], [+_WELL_4_X, +_WELL_1_Y] ];
WELL_RIGHT_4  = [ [+_WELL_5_X, +_WELL_2_Y], [+_WELL_6_X, +_WELL_1_Y] ];
WELL_RIGHT_5  = [ [+_WELL_3_X, -_WELL_2_Y], [+_WELL_4_X, -_WELL_1_Y] ];
WELL_RIGHT_6  = [ [+_WELL_5_X, -_WELL_2_Y], [+_WELL_6_X, -_WELL_1_Y] ];
WELL_RIGHT_7  = [ [+_WELL_3_X, -_WELL_4_Y], [+_WELL_4_X, -_WELL_3_Y] ];
WELL_RIGHT_8  = [ [+_WELL_5_X, -_WELL_4_Y], [+_WELL_6_X, -_WELL_3_Y] ];


/* MAIN MODULES */

module full_inset(part=PART_FULL) {
    /* The full volumetric model

    The upper side of the floor is located at z=0.

    If the selected part is "upper", a well grid is added to the bottom of the
    module.

    Arguments:
        parts:
            one of "full", "lower" or "upper"
            defining the height of the and other properties of the model
    */

    dx = FULL_BASE_X / 2;
    dy = FULL_BASE_Y / 2;

    translate([0, 0, -FLOOR]) {
        _select_part(part)
        translate([-dx, dy, 0])
        import("L-Boxx Mini Inner Volume.stl");
    }
}


module left_inset(part=PART_FULL, connector=false) {
    /* The left volumetric model

    The upper side of the floor is located at z=0.

    If the selected part is "upper", a well grid is added to the bottom of the
    module.

    If 'connector' is set to "true", a structure is added for the original
    separators.

    Arguments:
        parts:
            one of "full", "lower" or "upper"
            defining the height of the and other properties of the model
        connector:
            if set to "true", a structure is added for the original separators
    */

    difference() {

        full_inset(part);

        translate([+100 - MODULE_CUT_X_OUTER, 0, 0])
        cube(200, center=true);
    }

    if (connector) {
         translate([-MODULE_CUT_X_OUTER, 0, -FLOOR])
        _connector(side="left", part=part);
    }
}


module large_left_inset(part=PART_FULL, connector=false) {
    /* The large left volumetric model

    This spans the left module and middle module.

    The upper side of the floor is located at z=0.

    If the selected part is "upper", a well grid is added to the bottom of the
    module.

    If 'connector' is set to "true", a structure is added for the original
    separators.

    Arguments:
        parts:
            one of "full", "lower" or "upper"
            defining the height of the and other properties of the model
        connector:
            if set to "true", a structure is added for the original separators
    */

    difference() {

        full_inset(part);

        translate([+100 + MODULE_CUT_X_INNER, 0, 0])
        cube(200, center=true);
    }

    if (connector) {
        translate([MODULE_CUT_X_INNER, 0, -FLOOR])
            _connector(side="left", part=part);
    }
}


module middle_inset(part=PART_FULL, connector=false) {
    /* The middle volumetric model


    The upper side of the floor is located at z=0.

    If the selected part is "upper", a well grid is added to the bottom of the
    module.

    If 'connector' is set to "true", a structure is added for the original
    separators.

    Arguments:
        parts:
            one of "full", "lower" or "upper"
            defining the height of the and other properties of the model
        connector:
            if set to "true", a structure is added for the original separators
    */

    difference() {

        full_inset(part);

        translate([-100 - MODULE_CUT_X_INNER, 0, 0])
        cube(200, center=true);

        translate([+100 + MODULE_CUT_X_INNER, 0, 0])
        cube(200, center=true);
    }

    if (connector) {

        translate([+MODULE_CUT_X_INNER, 0, -FLOOR])
        _connector(side="left", part=part);

        translate([-MODULE_CUT_X_INNER, 0, -FLOOR])
        _connector(side="right", part=part);
    }
}


module right_inset(part=PART_FULL, connector=false) {
    /* The right volumetric module

    The upper side of the floor is located at z=0.

    If the selected part is "upper", a well grid is added to the bottom of the
    module.

    If 'connector' is set to "true", a structure is added for the original
    separators.

    Arguments:
        parts:
            one of "full", "lower" or "upper"
            defining the height of the and other properties of the model
        connector:
            if set to "true", a structure is added for the original separators
    */

    difference() {

        full_inset(part);

        translate([-100 + MODULE_CUT_X_OUTER, 0, 0])
        cube(200, center=true);
    }

    if (connector) {
        translate([MODULE_CUT_X_OUTER, 0, -FLOOR])
         _connector(side="right", part=part);
    }
}


module large_right_inset(part=PART_FULL, connector=false) {
    /* The large right volumetric module

    This spans the right module and middle module.

    The upper side of the floor is located at z=0.

    If the selected part is "upper", a well grid is added to the bottom of the
    module.

    If 'connector' is set to "true", a structure is added for the original
    separators.

    Arguments:
        parts:
            one of "full", "lower" or "upper"
            defining the height of the and other properties of the model
        connector:
            if set to "true", a structure is added for the original separators
    */

    difference() {

        full_inset(part);

        translate([-100 - MODULE_CUT_X_INNER, 0, 0])
        cube(200, center=true);
    }

    if (connector) {
        translate([-MODULE_CUT_X_INNER, 0, -FLOOR])
        _connector(side="right", part=part);
    }
}


module well_form(from, to=false, height=50, corner=INNER_WALLS) {
    /* Generates a well form to be cut out of a volumetric model

    If 'to' is set to a well, the cutout form will span from the top left point
    to the bottom right point defined by 'from' and 'to'

    Arguments:
        from:
            vector of two points defining a well
        to:
            optional vector of two points defining a well
        height:
            height of the form
        corner:
            defines the "roundness" of the bottom and sides of the form
    */

    join = 0.1;

    translate([0, 0, corner + join]) {

        _rounded_bottom(dx=corner, dy=corner)
        _well_outline(from, to=to);

        linear_extrude(height - corner)
        offset(r=corner)
        offset(delta=-corner)
        _well_outline(from, to=to);
    }
}


/* HELPER MODULES */

module _model_outline() {
    /* generates a 2D outline of the full volumetric model */

    projection()
    full_inset();
}


module _select_part(part=PART_FULL) {
    /* selects the full, upper or lower part of a module

    Example:
        _select_part(PART_UPPER) cube(200);

    Arguments:
        parts:
            one of "full", "lower" or "upper"
            defining the height of the module
    */

    leeway_upper = MODULE_CUT_LEEWAY;
    delta_z = (part == PART_UPPER) ? LOWER_PART_HEIGHT + leeway_upper : 0;

    translate([0, 0, -delta_z]) {

        difference() {

            children();

            if (part == PART_LOWER) {
                translate([0, 0, 200 + LOWER_PART_HEIGHT])
                cube(400, center=true);
            }

            if (part == PART_UPPER) {
                translate([0, 0, -200 + LOWER_PART_HEIGHT + leeway_upper])
                cube(400, center=true);
            }
        }
    }
}


module _well_outline(from, to=false, delta=OUTER_WALLS) {
    /* Generates a 2D well outline

    If 'to' is set to a well, the cutout form will span from the top left point
    to the bottom right point defined by 'from' and 'to'

    Arguments:
        from:
            vector of two points defining a well
        to:
            optional vector of two points defining a well
        delta:
            defines the distance to the outer wall
    */

    _to = (to) ? to : from;

    from_point_1 = from[0];
    from_point_2 = from[1];

    to_point_1 = _to[0];
    to_point_2 = _to[1];

    from_x = min(from_point_1.x, from_point_2.x, to_point_1.x, to_point_2.x);
    to_x = max(from_point_1.x, from_point_2.x, to_point_1.x, to_point_2.x);
    from_y = min(from_point_1.y, from_point_2.y, to_point_1.y, to_point_2.y);
    to_y = max(from_point_1.y, from_point_2.y, to_point_1.y, to_point_2.y);

    intersection() {

        translate([from_x, from_y, 0])
        square([to_x - from_x, to_y - from_y]);

        offset(r=-delta)
        _model_outline();
    }
}


module _rounded_bottom(dx=1, dy=1, layer_height=0.1) {
    /* Generates a rounded bottom of a module

    Example:
        _rounded_bottom(1, 1) cube(20);

    Arguments:
        dx:
            difference between start and end on x axis
        dy:
            height of the rounded bottom
        layer_height:
            height of each calculated layer
    */

    _join = 0.1;

    steps = dy / layer_height;
    angle_step = 90 / steps;

    translate([0, 0, -dy]) {

        for (i=[0:steps]) {

            dx_step = sin(angle_step * i) * dx;

            translate([0, 0, layer_height * i])
            linear_extrude(layer_height + _join)
            offset(r=dx_step)
            offset(delta=-dx)
            children();
        }
    }
}


module _connector(side="left", part=PART_FULL) {
    /* Generates a connector for the original separators

    Arguments:
        side:
            the side that the opening faces, either "left" or "right"
        parts:
            one of "full", "lower" or "upper"
            defining the height of the and other properties of the model
    */

    join = 0.1;
    connector_x = CONNECTOR_INNER_LENGHT + OUTER_WALLS + join;
    connector_y = CONNECTOR_INNER_WIDTH + 2 * OUTER_WALLS;
    connector_z = FULL_BASE_Z - INSET_HEIGHT;
    scaling = CONNECTOR_OPENING_UPPER / CONNECTOR_OPENING_LOWER;

    mirror_x = (side == "left") ? 0 : 1;

    _select_part(part)
    mirror([mirror_x, 0, 0])
    difference() {

        translate([-join, -connector_y / 2, 0])
        cube([connector_x, connector_y, connector_z]);

        translate([-join * 2, -CONNECTOR_INNER_WIDTH / 2, -1])
        cube([CONNECTOR_INNER_LENGHT + join, CONNECTOR_INNER_WIDTH, connector_z + 2]);

        translate([CONNECTOR_INNER_LENGHT + OUTER_WALLS / 2, 0, -1])
        linear_extrude(height=connector_z + 2, scale=scaling)
        square([OUTER_WALLS * 2, CONNECTOR_OPENING_LOWER], center=true);
    }
}

