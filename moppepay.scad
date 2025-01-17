include <BOSL2/std.scad>

hole_sep = 65;
hole_d = 8.3;
ring_w = 0.8;
ring_h = 1;

creditcard = [85.6, 53.98, 0.8];
credit_margin = 0.2;
creditbox_wall = 1;

creditcard_real = add_scalar(creditcard, credit_margin);
creditbox = add_scalar(creditcard_real, 2*creditbox_wall);

fingerhole = 16;

text_indent = 0.4;

$fn=40;

diff() {
    cuboid(creditbox, rounding = creditbox_wall, edges="Z") {
        align(FRONT, inside=true) cuboid(creditcard_real);
        tag("remove") position(FRONT) zcyl(h=creditbox[2], d=fingerhole);
        align(BOTTOM) {
            xcopies(hole_sep, 2) {
                tube(od=hole_d, h=ring_h, wall=ring_w);
            }
        }
        align(TOP) force_tag("remove") zrot(180) move([-35, -6.75, -text_indent]) linear_extrude(text_indent) import("assets/moppepay.svg");
    }

}
