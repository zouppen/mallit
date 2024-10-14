include <BOSL2/std.scad>
include <BOSL2/screws.scad>

wall = 4;
hand_w = 10;
inside = [72, 43, 35.7];
bar_width = 31.6;
chamfer_outer = 4/3;

// Calculated helpers
outer_size = inside + [2*wall, 2*wall, wall];

diff() {
    cuboid(outer_size, chamfer=chamfer_outer, edges=[TOP, FRONT, LEFT+BOTTOM, RIGHT+BOTTOM]) {
        align(TOP, inside=true) cuboid(inside, chamfer=-chamfer_outer, edges=TOP);
        // Hands
        for (pos = [LEFT, RIGHT]) {
            fwd(chamfer_outer) position(BACK+TOP+pos) cuboid([hand_w, wall+bar_width+chamfer_outer, wall], anchor=pos+FRONT+TOP, chamfer=chamfer_outer, edges=[TOP+LEFT, TOP+RIGHT, BACK+TOP, BACK+LEFT, BACK+RIGHT]) {
                align(BOTTOM+BACK) cuboid([hand_w, wall, outer_size[2]-wall], chamfer=chamfer_outer, edges=[BACK+LEFT, BACK+RIGHT]) {
                    tag("manual_brim") align(BOTTOM, inside=true) cube([hand_w,30,0.2]);
                }
            }
        }
        align(BACK+TOP, inside=true) cuboid([outer_size[0]-2*hand_w, wall, 4.8], chamfer=-chamfer_outer, edges=[TOP+LEFT, TOP+RIGHT]);
    }
}
