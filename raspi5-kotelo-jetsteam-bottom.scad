// This work is licensed under a Creative Commons (4.0 International
// License) Attribution-ShareAlike

include <BOSL2/std.scad>

origo = [31.6, 47, -5.4];

drill_d = 6.2;
drill_h = 5.5-1.2;
drill_xs = [-24.5,24.5];
drill_ys = [-19,39];
base_support=1;
screw_hole = 2.7;
layer_h = 0.1;
back_y = 50.5;
sd_w = 12;
sd_l = 11;

// Position of notch to ease filling it. Checked from the original
// model using PrusaSlicer.
notch_x = [0, 1.4, 2.6];
notch_y = [25, 41.305];
notch_z = [6, 14.7, 16.7];

diff() {
    down(origo[2]) force_tag("kotelo") import("assets/caselower.stl");

    // Screw recession
    tag("remove") for(y = drill_ys) for(x = drill_xs) {
            move([x, y, 0]) {
                cyl(d=drill_d, h=drill_h, anchor=BOTTOM, $fn=40);
                // Some support
                tag("base") cyl(d=drill_d+2*base_support, h=drill_h+base_support, anchor=BOTTOM, chamfer2=base_support, $fn=40);
                up(drill_h+layer_h) cyl(d=screw_hole, h=base_support, anchor=BOTTOM, $fn=40);
            }
        }

    // Fill notch
    left(origo[0]) fwd(origo[1]) {
        cuboid(p1=[notch_x[0], notch_y[0], notch_z[0]], p2=[notch_x[2], notch_y[1], notch_z[1]]);
        cuboid(p1=[notch_x[1], notch_y[0], notch_z[1]], p2=[notch_x[2], notch_y[1], notch_z[2]]);
    }

    // Screw thingys
    bot_wall = 2;
    screw_d = 3;
    slide = -7;
    extra_room = 0.3;
    for (x = [-23, 23]) {
        tag("remove") hull() for (y = [0, slide]) {
            move([x, y]) {
                cyl(d1=screw_d, d2=bot_wall+2*screw_d, h=bot_wall, anchor=BOTTOM, $fn = 30) {
                    // And one cylider on top
                    position(TOP) cyl(d=bot_wall+2*screw_d, h=extra_room, anchor=BOTTOM, $fn = 30);
                }
            }
        }
        hull() for (y = [0, slide]) {
            move([x, y]) {
                cyl(d=bot_wall+2*screw_d+3, h=bot_wall+1.2, anchor=BOTTOM, $fn = 30);
            }
        }
        tag("remove") move([x, slide]) cyl(d=bot_wall+2*screw_d, h=bot_wall, anchor=BOTTOM, $fn = 30);
    }

    // Cut for the SD card
    tag("remove") back(back_y) cuboid([sd_w, sd_l, 5], anchor=BOTTOM+BACK);
}
