include <sortimo-insets.scad>;


/* Uncomment and adjust this constants if needed, values are in mm. */

// OUTER_WALLS        =  1.6;
// INNER_WALLS        =  0.8;
// FLOOR              =  1.2;
// LOWER_PART_HEIGHT  = 22.0;  // half of full height


part = PART_FULL;  // or PART_LOWER or PART_UPPER
connector = false;

difference() {

    /* Select wich basic inset to use:
    - full_inset
    - left_inset
    - large_left_inset
    - middle_inset
    - right_inset
    - large_right_inset
    */

    middle_inset( part=part, connector=connector );

    /* Subtract the wells from the selected base form

    - WELL_LEFT_[1-8]
    - WELL_MIDDLE_[1-8]
    - WELL_RIGHT_[1-8]

    You can also define a 'from' and 'to' well to create larger cutouts.
    */

    well_form( from=WELL_MIDDLE_1, to=WELL_MIDDLE_2 );
    // well_form( from=WELL_MIDDLE_2 );
    well_form( from=WELL_MIDDLE_3 );
    well_form( from=WELL_MIDDLE_4 );
    well_form( from=WELL_MIDDLE_5 );
    well_form( from=WELL_MIDDLE_6 );
    well_form( from=WELL_MIDDLE_7 );
    well_form( from=WELL_MIDDLE_8 );

}
