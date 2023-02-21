Cubes with rounded corners
==========================

    rounded_cube(
        dimensions=dimensions,
        corner_radius=5,
        top_radius=2,
        bottom_radius=0,
        center=true
    );

![example case](case.png)


usage
-----

This can be used (more or less) as a drop-in replacement for `cube()`.

In your source file use the command `use <rounded_cube/rounded_cube.scad>` to
import the module.

The modules have the signature:

- `rounded_cube(dimensions, corner_radius, top_radius=-1, bottom_radius=-1, center=false)`

Description of the parameters:

- `dimensions`:     vector for [length, width, height], same as in cube()
- `corner_radius`:  corner radius of the side corners
- `top_radius`:     radius of the top corners [default=corner_radius]
- `bottom_radius`:  radius of the bottom corners [default=corner_radius]
- `center`:         center the model  [default=false]


