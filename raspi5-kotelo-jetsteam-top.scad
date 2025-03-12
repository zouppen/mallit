// This work is licensed under a Creative Commons (4.0 International
// License) Attribution-ShareAlike

include <BOSL2/std.scad>

// This causes segment angle normals to be no more than 1° apart as
// long as the segment length is at least 0.2.
$fa = 1;
$fs = 0.2;

// Dimensions checked from the original model using PrusaSlicer.
stuff_z = 27.75;

shelf_h = 2;
shelf_l = 91;
shelf_adjust = [-27.8, 1.8, stuff_z];
dcdc_w = 25;
dcdc_h = 20.6;
dcdc_screw_sep = 58;
ziptie_hole = [1.5, 3];
ziptie_extra = 3;
shelf_gap = dcdc_screw_sep-8;

origo = [-31.6, -47, -5.4];

stuff_h = dcdc_h + shelf_h;
eps = 0.1;
top_z = 29.8;
logo_h = 0.4;
logo_scale = 0.15;
logo_pos = [0, origo[1], top_z+stuff_h-16];

drill_d = 6.2;
drill_h = [16.7, 37.9];
drill_xs = [[-26.2,27.2], [-27.6,28.6]];
drill_ys = [-37,46.5];
drill_fill = 10; // Hack to fill the drill hole
drill_fill_inner = 3.4;
hanging_shelf = false;

// Position of notch to ease filling it. Checked from the original
// model using PrusaSlicer.
notch_x = [-0.1, 1.2, 2.7];
notch_y = [25, 41.305];
notch_z = [6, 14.7, 16.9];

back_y = 50.5-2.6;
sd_w = 12+2;
sd_wedge = 4.5;
sd_wedge_z = 0.6;

module separate(matrix, spread, cutpath) {
    // Transform the object, partition, and then transform back
    multmatrix(rot_inverse(matrix))
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
        //extra = (shelf_l-dcdc_screw_sep+ziptie_extra)/2;
        cuboid([dcdc_w, shelf_l, shelf_h], anchor=BOTTOM+LEFT, chamfer=6.8, edges=[LEFT+BACK]) {
            // Holes to it (do not punch top support bridge layer!)
            position(BOTTOM) ycopies(dcdc_screw_sep, 2) {
                // Zip tie slots instead of holes
                tag("remove") cuboid([ziptie_hole[0], ziptie_hole[1], shelf_h+eps-0.2], anchor=BOTTOM);
            }
            // Keep out hole, magic values
            tag("remove") back(3.6) position(FWD+LEFT) cuboid([6.5,6,10], anchor=FWD+LEFT);

            // Remove the middle
            position(LEFT) down(hanging_shelf ? eps : 0) tag("remove") cuboid([dcdc_w+eps, shelf_gap, shelf_h], anchor=LEFT);
            // Add little support enforer plateau
            side_l = (shelf_l-shelf_gap)/2;
            if (!hanging_shelf) {
                for (side = [FWD, BACK]) position(TOP+side+RIGHT) cuboid([2, side_l, 0.2], anchor=BOTTOM+RIGHT+side);
            }
        }
    }

    // Enlarge screw holes
    tag("remove") for(yi = [0,1]) for(x = drill_xs[yi]) {
            move([x,drill_ys[yi],top_z+stuff_h]) cyl(d=drill_d, h=drill_h[yi], anchor=TOP) {
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
    move(logo_pos) xrot(90) {
        logo_size = [150.290, 111.372];

        minkowski() {
            linear_extrude(0.01) {
                scale(logo_scale) move(logo_size/-2) import("assets/pupu-logo.svg");
            }
            wedge([0.01, logo_h, logo_h]);
        }
    }

    // Remove the matching structure for bottom part notch
    tag("remove") move(origo) {
        cuboid(p1=[notch_x[0], notch_y[0], notch_z[0]], p2=[notch_x[2], notch_y[1], notch_z[1]]);
        cuboid(p1=[notch_x[1], notch_y[0], notch_z[1]], p2=[notch_x[2], notch_y[1], notch_z[2]]);
    }

    up(sd_wedge_z) back(back_y) {
        // Shelf for the SD card
        tag_diff("keep") wedge([sd_w, sd_wedge, sd_wedge], anchor=BOTTOM+FRONT, spin=180) {
            for (side = [LEFT, RIGHT]) {
                position(BOTTOM+BACK+side) cube([1,sd_wedge+2.6,3], anchor=TOP+BACK+side);
            }
        }
        // Add opening for the SD card
        tag("remove") cube([sd_w, sd_wedge, sd_wedge], anchor=TOP+FRONT);
        // Cut the stupid inset
        buttonthing_cutbox = [40, 5, 10];
        tag("remove") cuboid(buttonthing_cutbox, anchor=BOTTOM+BACK);
    }
}
