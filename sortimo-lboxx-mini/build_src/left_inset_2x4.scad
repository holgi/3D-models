include <sortimo-insets.scad>;

part = PART_FULL;
connector = false;

difference() {
    left_inset( part=part, connector=connector );

    well_form( WELL_LEFT_1 );
    well_form( WELL_LEFT_2 );
    well_form( WELL_LEFT_3 );
    well_form( WELL_LEFT_4 );
    well_form( WELL_LEFT_5 );
    well_form( WELL_LEFT_6 );
    well_form( WELL_LEFT_7 );
    well_form( WELL_LEFT_8 );
}
