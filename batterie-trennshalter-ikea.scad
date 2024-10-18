include <BOSL2/std.scad>
include <BOSL2/screws.scad>

hole_d = 30.5;
inpart_h = 9;
top_d = 40;
top_h = 4;
guide_l = 10;
screw = "9/8-15,1";
tol = 0.4;

diff() {
    cyl(d=hole_d, h=inpart_h, $fn=200) {
        attach(TOP, BOTTOM) cyl(d=top_d, h=top_h, chamfer1=0.6, $fn=6) {
            attach(TOP) screw_hole(screw, anchor=TOP, thread=true, oversize=tol, $fn=200);
        }
    }
}
