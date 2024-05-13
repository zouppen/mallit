include <BOSL2/std.scad>
include <BOSL2/screws.scad>

wall = 5;
hand_w = 10;
inside = [80, 43, 35.2];
bar_width = 31.6;
chamfer_outer = 1;

// Calculated helpers
outer_size = inside + [2*wall, 2*wall, wall];

diff() {
    cuboid(outer_size, chamfer=chamfer_outer, edges=[TOP, FRONT, LEFT+BOTTOM, RIGHT+BOTTOM]) {
        align(TOP, inside=true) cuboid(inside, chamfer=-chamfer_outer, edges=TOP);
        // Hands
        for (pos = [LEFT, RIGHT]) {
            fwd(chamfer_outer) position(BACK+TOP+pos) cuboid([hand_w, wall+bar_width+chamfer_outer, wall], anchor=pos+FRONT+TOP, chamfer=chamfer_outer, edges=[TOP+LEFT, TOP+RIGHT, BACK+TOP, BACK+LEFT, BACK+RIGHT]) {
                align(BOTTOM+BACK) cuboid([hand_w, wall, outer_size[2]-wall], chamfer=chamfer_outer, edges=[BACK+LEFT, BACK+RIGHT, BACK+BOTTOM]);
            }
        }
    }
}
