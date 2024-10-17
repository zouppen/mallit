// This work is licensed under a Creative Commons (4.0 International
// License) Attribution-ShareAlike

include <BOSL2/std.scad>

// Dimensions checked from the original model with PrusaSlicer.
// case_top = 33.34;
// case_width = 60.4;

// // DC converter dimensions
//
// screw_support_d = 8.4;
// screw_support_h = 4; // Make it thicker than the wall to support screws
//
//
// fine_tune = [[1,0.5], [-1,0.5]]; // Snap to hexagon holes of the case

stuff_z = 27.75;

shelf_h = 2;
shelf_l = 91;
shelf_adjust = [-27.8, 1.8, stuff_z];
dcdc_w = 25;
dcdc_h = 20.6;
dcdc_screw_sep = 58;
ziptie_hole = [1.5, 3];
ziptie_extra = 3;

stuff_h = dcdc_h + shelf_h;
eps = 0.1;
top_z = 29.8;
logo_h = 0.4;
logo_scale = 0.13;
logo_pos = [0.5, -33, top_z+stuff_h-logo_h];

drill_d = 6.2;
drill_h = [16.7, 37.9];
drill_xs = [[-26.2,27.2], [-27.6,28.6]];
drill_ys = [-37,46.5];
drill_fill = 10; // Hack to fill the drill hole
drill_fill_inner = 3.4;

module separate(matrix, spread, cutpath) {
    // Transform the object, partition, and then transform back
    multmatrix(matrix_inverse(matrix))
        partition([200,200,200], spread=spread, cutpath=cutpath)
        multmatrix(matrix) children();
}

diff() {
    // Cut it into two pieces
    up(stuff_h/2) separate(xrot(-90)*down(stuff_z), spread=stuff_h, cutpath="flat") {
        force_tag("runkopalat") import("assets/caseupper.stl");
    }

    // Fill the gap with projection
    force_tag("") up(stuff_z) linear_extrude(stuff_h) projection(cut=true) down(stuff_z) import("assets/caseupper.stl");


    tag_diff("hylly") move(shelf_adjust) {
        // Shelf
        extra = (shelf_l-dcdc_screw_sep+ziptie_extra)/2;
        cuboid([dcdc_w+extra, shelf_l, shelf_h], anchor=BOTTOM+LEFT, chamfer=6.8, edges=[LEFT+BACK]) {
            // Holes to it (do not punch top support bridge layer!)
            right(dcdc_w/2) position(LEFT+BOTTOM) ycopies(dcdc_screw_sep, 2) {
                // Zip tie slots instead of holes
                tag("remove") cuboid([ziptie_hole[0], ziptie_hole[1], shelf_h+eps-0.2], anchor=BOTTOM);
            }
            // Keep out hole, magic values
            tag("remove") back(3.6) position(FWD+LEFT) cuboid([6.5,6,10], anchor=FWD+LEFT);

            // Lighten the shelf
            tag("remove") cuboid([dcdc_w+extra, shelf_l, shelf_h+eps], chamfer=dcdc_w+extra, edges=[FWD+LEFT, BACK+LEFT]); {
                // And lighten the hacky supports
                tag("remove") position(RIGHT+BOTTOM) cube([extra, shelf_l, shelf_h-0.2], anchor=RIGHT+BOTTOM);
            }
        }
    }

    // Enlarge screw holes
    tag("remove") for(yi = [0,1]) for(x = drill_xs[yi]) {
            move([x,drill_ys[yi],top_z+stuff_h]) cyl(d=drill_d, h=drill_h[yi], anchor=TOP, $fn=40) {
                // Put countersink cone on the bottom
                position(BOTTOM) cyl(d2=drill_d, d1=0, h=drill_d/2, anchor=TOP);

                // Fill the original hole of the in first
                if (yi == 0) {
                    // Not using tube() since we need to drill the
                    // inner hole because JetSteam put clever bridges
                    // which we don't need in here.
                    tag("filling") position(BOTTOM) cyl(d=drill_d, h=drill_fill, anchor=TOP);
                    tag("remove") position(BOTTOM) cyl(d=drill_fill_inner, h=drill_fill, anchor=TOP);
                }
            }
        }

    // Logo
    force_tag("remove") move(logo_pos) linear_extrude(logo_h+eps) {
        scale(logo_scale) move([150.290, 111.372, 0]/-2) import("assets/pupu-logo.svg");
    }
}
