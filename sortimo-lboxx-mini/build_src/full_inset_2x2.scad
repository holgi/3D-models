include <sortimo-insets.scad>;

part = PART_FULL;
connector = false;

difference() {
    full_inset( part );

    well_form( from=WELL_LEFT_1,   to=WELL_MIDDLE_3 );
    well_form( from=WELL_MIDDLE_2, to=WELL_RIGHT_4  );
    well_form( from=WELL_LEFT_5,   to=WELL_MIDDLE_7 );
    well_form( from=WELL_MIDDLE_6, to=WELL_RIGHT_8  );

}
