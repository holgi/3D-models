include <sortimo-insets.scad>;

part = PART_FULL;
connector = false;

difference() {
    large_left_inset( part=part, connector=connector );

    well_form( from=WELL_LEFT_1, to=WELL_MIDDLE_4 );
    well_form( from=WELL_LEFT_5, to=WELL_MIDDLE_8 );
}
