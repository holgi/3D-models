include <sortimo-insets.scad>;

part = PART_FULL;
connector = false;

difference() {
    full_inset( part );

    well_form( from=WELL_LEFT_1, to=WELL_RIGHT_2 );
    well_form( from=WELL_LEFT_3, to=WELL_RIGHT_4 );
    well_form( from=WELL_LEFT_5, to=WELL_RIGHT_6 );
    well_form( from=WELL_LEFT_7, to=WELL_RIGHT_8 );
}
