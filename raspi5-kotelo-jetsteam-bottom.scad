// This work is licensed under a Creative Commons (4.0 International
// License) Attribution-ShareAlike

include <BOSL2/std.scad>

bottom_z = -5.4;

drill_d = 6.2;
drill_h = 5.5-1.2;
drill_xs = [-24.5,24.5];
drill_ys = [-19,39];
base_support=1;
screw_hole = 2.7;
layer_h = 0.1;

diff() {
    down(bottom_z) force_tag("kotelo") import("assets/caselower.stl");

    // Screw recession
    tag("remove") for(y = drill_ys) for(x = drill_xs) {
            move([x, y, 0]) {
                cyl(d=drill_d, h=drill_h, anchor=BOTTOM, $fn=40);
                // Some support
                tag("base") cyl(d=drill_d+2*base_support, h=drill_h+base_support, anchor=BOTTOM, chamfer2=base_support, $fn=40);
                up(drill_h+layer_h) cyl(d=screw_hole, h=base_support, anchor=BOTTOM, $fn=40);
            }
        }
}
