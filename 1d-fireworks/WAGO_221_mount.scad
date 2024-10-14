// ////////////////////////////////////////////////
//
// WAGO 221 mount
//
// Creates a single row or double row set of 221 blocks
// with mounting tabs/ears at either end.
//
// Created - 2017/01/01 by Joo Chung
//
//
// Downloaded from https://www.thingiverse.com/thing:2075219/
//
// - added an extra module `wago_mount(blocks, join=1)` to use it in another project
// - added an extra function `wago_mount_width(blocks)` for calculating the complete mount width
// - fixed warnings about calls to mirror() without vector
// - prefixed all functions and modules with `wago_` as a poor mans implementation of a namespace
// ////////////////////////////////////////////////

// ////////////////////////////////////////////////
// vector of blocks. each element specifies the number of conductors for that block
// EDIT THIS
blocks = [2,2,2,2,2]; // a single 5 conductor blocks
// blocks = [5, 3, 2]; // a set of 5 conductor, 3 conductor, 2 conductor blocks
// blocks = [5, 5, 5]; // a set of three 5 conductor blocks
// blocks = [2]; // a single 2 conductor block
// blocks = [3]; // a single 3 conductor block


// ////////////////////////////////////////////////
// Mirror the mount, stand it up, and put tabs on bottom.
// 0 - no mirror, 1 - mirror, rotate so its standing up, and reposition tabs
// 2 - mirror, rotate so that they are laying flat, and reposition tabs.
// EDIT THIS
body_shape = 0;

// ////////////////////////////////////////////////
// Tabs - include or exclude mounting tabs
// EDIT THIS: 0 - no tabs, 1 - tabs
tabs      =  1;
// EDIT THIS: radius of hole in tab
tabradius =  2.6;
// EDIT THIS: thickness of tab
tabheight =  4;
// EDIT THIS: Set width and length of the tab. (tab is basically a square)
tabwidth  = 10;



// ////////////////////////////////////////////////
// Block dimensions in mm -- DO NOT EDIT
conwidth   =  5.6; // width of a single conductor
// DO NOT EDIT
border     =  1.75; // block transparent plastic border
// DO NOT EDIT
blockdepth = 18.25;
// DO NOT EDIT
fudge      =  0.2;


// ////////////////////////////////////////////////
// OpenSCAD special variables -- DO NOT EDIT
$fa = 1;
// DO NOT EDIT
$fs = 0.4;


// ////////////////////////////////////////////////
// Functions

// block width
function wago_bw(x) = conwidth*x+border+fudge;

// mount width (list of blocks, index, max index)
function wago_mw(block_list, i, n) = ( i==0 ? wago_bw(block_list[i]) + 2 + wago_mw(block_list, i+1, n) : (i < n ? wago_bw(block_list[i]) + 2 + wago_mw(block_list, i+1, n) : 0));

// full mount width, including closing wall
function wago_mount_width(block_list) = wago_mw(block_list, 0, len(block_list))+ 2;

// ////////////////////////////////////////////////
// Modules

module wago_tab(width, hole, thickness) {
    difference() {
        union () {
            cylinder(thickness,width/2,width/2, true);
            translate([width/4,0,0]) cube([width/2,width,thickness], true);
        }
    cylinder(width,hole,hole, true);
    }
}


module wago_shoulder (depth) {
    difference () {
        union () {
            cube([2, blockdepth, 3.25], false);
            translate([0,0,3.25]) cube([2.25, blockdepth, 2], false);
        }
        translate([0,0,2]) cube([2.25,2,3.25], false);
        translate([2,blockdepth-4,2]) cube([0.25,4,3.25], false);
    }
}


module wago_backshoulder (height) {
    difference() {
        union() {
            translate([0, 2, 0]) cube ([2, 1.25, 10.15]);
            cube ([2.25, 2, 10.15]);
        }
        translate([0,0,10.15-2]) cube([2.25,3.25,2]);
        translate([2,0,2]) cube([1.25,3.25,3.25]);
    }
}


// WAGO 221 block
module wago_block (nconn) {
    blockwidth = wago_bw(nconn);

    // base
    translate([2,2,0]) cube([blockwidth, blockdepth, 2], false);

    // back headboard
    translate([0,blockdepth+2,0]) cube([blockwidth+4, 2, 10.15], false);

    // back lip
    translate([0,blockdepth,10.15]) cube([blockwidth+4, 4, 2], false);

    // front lip
    //translate([0,0,0]) cube([blockwidth+4, 2, 2.5], false);

    // left shoulder and right shoulders
    translate([0,2,0]) wago_shoulder();
    translate([blockwidth+4,2,0]) mirror([1,0,0]) wago_shoulder();

    // back left and shoulder
    translate([0, blockdepth-1.25, 0]) wago_backshoulder();
    translate([blockwidth+4, blockdepth -1.25, 0]) mirror([1,0,0]) wago_backshoulder();

}


module wago_mount(block_list=blocks, join=1) {
    // a single strip of wago mounts for use in other projects

    cut_size = [wago_mount_width(block_list) + 2, blockdepth + 4, 15];

    difference() {
        // mount, as defined by the original module
        translate([0, -2, -2])
            for (i=[0:len(block_list)-1]) {
                offset = (i==0) ? 0 : wago_mw(block_list, 0, i);
                translate([offset, 0, 0]) wago_block(block_list[i]);
            }

        // cut off excess material
        translate([-1, blockdepth + join, -3])
            cube(cut_size);
        translate([-1, -1, -cut_size.z - join])
            cube(cut_size);
    }
}



// ////////////////////////////////////////////////
// MAIN BODY
mountwidth=wago_mw(blocks, 0, len(blocks));
if (body_shape==0) { // No mirror. Single row of blocks
    // create array of blocks
    for (i=[0:len(blocks)-1]) {
        offset = (i==0) ? tabwidth : tabwidth + wago_mw(blocks, 0, i);
        translate([offset, 0, 0]) wago_block(blocks[i]);
    }

    // left and right tabs
    if (tabs==1) {
        translate([tabwidth/2,(blockdepth+4)/2,tabheight/2]) wago_tab (tabwidth, tabradius, tabheight);
        translate([mountwidth+2+tabwidth+tabwidth/2,(blockdepth+4)/2,tabheight/2]) mirror([1,0,0]) wago_tab (tabwidth, tabradius, tabheight);
    }
} else if (body_shape==1) { // Mirrored. two rows of blocks, back to back.
    // Row #1. Stand up on headboard.
    rotate([-90,0,0]) for (i=[0:len(blocks)-1]) {
        offset = (i==0) ? tabwidth : tabwidth + wago_mw(blocks, 0, i);
        translate([offset, 0, -1]) wago_block(blocks[i]);
    }

    // Row #2. Opposite rotation. Stand up on headbord
    rotate([90,0,0]) mirror ([0, 1, 0]) for (i=[0:len(blocks)-1]) {
        offset = (i==0) ? tabwidth : tabwidth + wago_mw(blocks, 0, i);
        translate([offset, 0, -1]) wago_block(blocks[i]);
    }

    // left and right tabs
    if (tabs==1) {
        translate([tabwidth/2,0,-blockdepth-tabheight/2]) wago_tab (tabwidth, tabradius, tabheight);
        translate([mountwidth+2+tabwidth+tabwidth/2,0,-blockdepth-tabheight/2]) mirror([1,0,0]) wago_tab (tabwidth, tabradius, tabheight);
    }
} else if (body_shape==2) {
    // Row #1.
    for (i=[0:len(blocks)-1]) {
        offset = (i==0) ? tabwidth : tabwidth + wago_mw(blocks, 0, i);
        translate([offset, -blockdepth-6, -1]) wago_block(blocks[i]);
    }

    // Row #2. Flip
    mirror ([0, 1, 0]) for (i=[0:len(blocks)-1]) {
        offset = (i==0) ? tabwidth : tabwidth + wago_mw(blocks, 0, i);
        translate([offset, -blockdepth, -1]) wago_block(blocks[i]);
    }

    // left and right tabs
    if (tabs==1) {
        translate([tabwidth/2,-3,(tabheight-2)/2]) wago_tab (tabwidth, tabradius, tabheight);
        translate([mountwidth+2+tabwidth+tabwidth/2,-3,(tabheight-2)/2]) mirror([1,0,0]) wago_tab (tabwidth, tabradius, tabheight);
    }
}


