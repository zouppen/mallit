include <BOSL2/std.scad>

// This causes segment angle normals to be no more than 1° apart as
// long as the segment length is at least 0.2.
$fa=1;
$fs=0.2;
$align_msg = false;

// Cable pipe to my basement
outer_d = 51.1;
pipe_l = 205;
wall = 2;
ring = 10;
ring_h = 1;
cut = 5;

diff() {
    tube(h=pipe_l, od=outer_d, wall=wall) {
        position(BOTTOM) tube(h=ring_h, od=outer_d+2*ring, id=outer_d-2*wall, anchor=TOP);
        position(BOTTOM+LEFT) left(cut) tag("remove") cuboid([ring,$parent_size[1],3*ring_h], anchor=RIGHT);
    }
}
