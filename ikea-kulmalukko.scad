include <BOSL2/std.scad>
include <BOSL2/screws.scad>

// This is for my IKEA shelf but works with any cover plate
// basically. It's a plastic part which keeps a shelf cover in
// place. It's difficult to explain and this is probably not very
// useful to others, but added as a simple BOSL2 example.

screw_lift = 9;
screw_base = 8;
screw_base_extra = 2;
screw_d = 4;
base_w = 4;

corner_d = 4;
corner_h = 20-1.5;
corner_w = 30;
corner_base_h = 20;

module screw_support() {
    cyl(d = screw_base+screw_base_extra, h=screw_lift, $fn=50, anchor=BOTTOM) {
        align(TOP, inside=true) cyl(d1=0, d2=screw_base, h=screw_base/2, $fn=50);
        align(TOP, inside=true) cyl(d=screw_d, h=screw_lift);
        children();
    }
}

diff() {
    cuboid([corner_w, screw_lift, corner_base_h + corner_h]) {
        align(BOTTOM+FWD, inside=true) cuboid([corner_w, corner_d, corner_h]);
        up(10-1.5/2) for (pos = [-7, 7]) {
            right(pos) attach(FRONT) xrot(180) screw_support();
        }
    }
}
