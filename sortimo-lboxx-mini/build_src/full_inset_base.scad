include <sortimo-insets.scad>;

part = PART_FULL;
connector = false;

difference() {
    full_inset( part );

    well_form( from=WELL_LEFT_1, to=WELL_RIGHT_8 );
}
