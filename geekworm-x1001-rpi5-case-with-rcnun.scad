include <BOSL2/std.scad>

// Dimensions checked from the original model with PrusaSlicer.
case_top = 33.34;
case_width = 60.4;

// DC converter dimensions
dcdc_screw_sep = 58;
screw_support_d = 8.4;
screw_support_h = 4; // Make it thicker than the wall to support screws
screw_hole_d = 2;
dcdc_w = 25;
fine_tune = [[1,0.5], [-1,0.5]]; // Snap to hexagon holes of the case

// Credits of original work to SaveYourBacon, see .md file in external_assets/
import("external_assets/Geekworm X1001 RPi 5 Case - Top.stl");

diff() up(case_top) back(case_width/2 - dcdc_w/2) {
    xcopies(dcdc_screw_sep, 2) {
        // Screw base, allow fine tuning of screw hole bases
        move(fine_tune[$idx]) {
            cyl(d=screw_support_d, h=screw_support_h, anchor=TOP, realign=true, $fn=6);
        }

        tag("remove") cyl(d=screw_hole_d, h=screw_support_h, anchor=TOP, $fn=12);
    }
}
