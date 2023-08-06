include <sortimo-insets.scad>;

difference() {
    left_inset( part="lower", connector=false );

    well_form( from=WELL_LEFT_1, to=false );

    well_form( from=WELL_LEFT_3, to=WELL_LEFT_4 );
    well_form( from=WELL_LEFT_2, to=WELL_LEFT_4 );
    well_form( from=WELL_LEFT_3, to=WELL_LEFT_5 );

    well_form( from=WELL_LEFT_6, to=false );

    well_form( from=WELL_LEFT_7, to=WELL_LEFT_8 );
}
