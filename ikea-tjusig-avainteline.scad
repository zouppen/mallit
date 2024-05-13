include <BOSL2/std.scad>
include <BOSL2/screws.scad>

wall = 5;
hand_w = 10;
inside = [80, 43, 35.2];
bar_width = 31.6;
chamfer_outer = 1;

// Calculated helpers
outer_size = inside + [2*wall, 3*wall+bar_width, wall];
cutbox_bar = [inside[0]+2*wall, bar_width, inside[2]];
cutbox_hand = [outer_size[0]-2*hand_w, wall+bar_width, outer_size[2]];

echo(outer_size[2]-wall);

diff() {
    cuboid(outer_size, chamfer=chamfer_outer) {
        back(wall) align(TOP+FRONT, inside=true) cuboid(inside, chamfer=-chamfer_outer, edges=TOP);
        align(BACK, inside=true) cuboid(cutbox_hand, chamfer=-chamfer_outer,
                                        edges=[TOP+LEFT, TOP+RIGHT]);
        fwd(wall) align(BACK+BOTTOM, inside=true) cuboid(cutbox_bar);
    }
}
