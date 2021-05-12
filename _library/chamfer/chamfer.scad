/*

Create Chamfers For Cubes

Most important module:

    chamfered_cube(cube_size, radius, edges=[0:11], center=false)

It is important to understand the numbering of the edges:


          +--------- 10 ---------+
         /|                     /|
        / |                    / |
      11  |                   9  |
      /   |                  /   |
     /    |                 /    |
    +---------- 8 ---------+     |
    |     |                |     |
    |     |                |     |
    |     7                |     6
    |     |                |     |
    |     |                |     |
    |     |                |     |
    |     |                |     |
    |     |                |     |
    4     |                5     |
    |     |                |     |
    |     |                |     |
    |     +---------– 2 ---|-----+
    |    /                 |    /
    |   /                  |   /
    |  3                   |  1
    | /                    | /
    |/                     |/
    +---------- 0 ---------+


A call to `chamfered_cube([10, 20, 30], 1, edges=[8:11])` will give you a
cube with the size of 10 x 20 x 30, the upper side will have chamfers.

*/

CHAMFER_EDGES = [
    [[1, 0, 0], [  0, 270,   0], 0],
    [[1, 1, 0], [ 90, 270,   0], 1],
    [[0, 1, 0], [  0, 270, 180], 0],
    [[0, 1, 0], [ 90,   0,   0], 1],

    [[0, 0, 0], [  0,   0,   0], 2],
    [[1, 0, 0], [  0,   0,  90], 2],
    [[1, 1, 0], [  0,   0, 180], 2],
    [[0, 1, 0], [  0,   0, 270], 2],

    [[0, 0, 1], [  0,  90,   0], 0],
    [[1, 0, 1], [270,  90,   0], 1],
    [[1, 1, 1], [  0,  90, 180], 0],
    [[0, 0, 1], [270,   0,   0], 1],
];

_JOIN = 0.1;

function multiply_vector(v1, v2) =
    len(v1) == len(v2) ?
    [for (i=[0:(len(v1)-1)]) v1[i] * v2[i]] :
    undef;


module basic_chamfer(length, radius) {
    /* returns a basic chamfer

    an extra margin is already added in all dimensions and positioned
    accordingly.
    */
    join_length = length + 2 * _JOIN;
    difference() {
        translate([-_JOIN, -_JOIN, -_JOIN]) cube([radius + _JOIN, radius + _JOIN, join_length]);
        translate([radius, radius, -2 * _JOIN]) cylinder(join_length + 2 * _JOIN, d=radius * 2, $fn=60);
    }
}

module chamfer_edge(cube_size, radius, edge) {
    /* returns one chamfer for one edge of an cube */
    translation_vektor = CHAMFER_EDGES[edge][0];
    rotation = CHAMFER_EDGES[edge][1];
    length_index = CHAMFER_EDGES[edge][2];

    length = cube_size[length_index];
    translation = multiply_vector(cube_size, translation_vektor);

    translate(translation) rotate(rotation) basic_chamfer(length, radius);
}

module chamfered_cube(cube_size, radius, edges=[0:11], center=false) {
    /* returns a cube with chamfers applied to the specified edges */
    translation = center ? [for(i=cube_size) i/-2] : [0, 0, 0];
    translate(translation) {
        difference() {
            cube(cube_size);
            for (edge=edges) {
                chamfer_edge(cube_size, radius, edge);
            }
        }
    }
}


chamfered_cube([30, 20, 10], radius=1, edges=[8:11], center=true);
