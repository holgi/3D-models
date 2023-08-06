include <sortimo-insets.scad>;

part = PART_FULL;
connector = false;

difference() {
    large_right_inset( part=part, connector=connector );

    well_form( from=WELL_MIDDLE_1, to=WELL_RIGHT_4 );
    well_form( from=WELL_MIDDLE_5, to=WELL_RIGHT_8 );
}
