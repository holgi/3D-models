

module rounded_bottom(dx=1, dy=1, layer_height=0.1) {

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

rounded_bottom() square(20);
