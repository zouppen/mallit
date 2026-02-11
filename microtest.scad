// Microtest Ethernet tester battery cover

include <BOSL2/std.scad>

// This causes segment angle normals to be no more than 1° apart as
// long as the segment length is at least 0.2.
$fa=1;
$fs=0.2;
$align_msg = false;

luukku = [48, 70.8, 2.3];
luukku_round = 1.4;
guide_pos = 17;
triangle_h = 2.4;
triangle_l = 35;
overhang = 2;
overhang_w = 2.8;
overhang_h = 1.6;
lock_w = 12;
lock_h = 4.5;
lock_overhang = 0.5;

cuboid(luukku, rounding=luukku_round, edges="Z") {
    for(pos=[-1, 1]) {
        right(pos*guide_pos) position(pos*LEFT+TOP) {
            cuboid([triangle_h*2, triangle_l, triangle_h], anchor=BOTTOM, chamfer=triangle_h, edges=[TOP+LEFT, TOP+RIGHT]);
            fwd(overhang) position(FWD) cuboid([overhang_w, overhang*3, overhang_h], anchor=FWD+BOTTOM, chamfer=overhang_h, edges=BACK+TOP);

        }
    }
    position(BACK+TOP) cuboid([lock_w,3,lock_h], anchor=BOTTOM+BACK) {
        position(BACK+BOTTOM) wedge([$parent_size[0], lock_overhang,$parent_size[2]], anchor=FWD+BOTTOM);
    }
};
