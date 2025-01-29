include <BOSL2/std.scad>

$align_msg=false;

ring_h = 1.05;
hole_sep = 65;
hole_d = 8.4;
screw_d = 4.2;
screw_wall = 1;

creditcard = [85.6, 53.98, 0.6];
creditbox = [100, 65, 6];
credit_margin = 0.4;
rounding = 10;

tape_indent = [45, 20, 0.8];
tape_rounding = 1;

creditcard_real = add_scalar(creditcard, credit_margin);

finger_curve = 8;
finger_w = 28;
finger_h = 6;

text_indent = 0.4;
raise = 4.2;
eps = 0.01;

color=0;

module color_tag(my_color, zero, hit, miss) {
    my_tag = color == 0 ? zero : color == my_color ? hit : miss;

    if (my_tag != undef) {
        tag(my_tag) children();
    }
}

module creditbox() {
    ch = 3;

    // Box boundaries just for the attachment
    prismoid(size1=[creditbox[0], creditbox[1]], size2=[creditbox[0]-2*ch, creditbox[1]-ch], h=creditbox[2], rounding1=rounding, rounding2=0.7*rounding, shift=[0,-ch/2], $fn=200) {
        children();
    }
}

module credit_hole(margin) {
    tag("remove") align(FRONT+BOTTOM, inside=true, shiftout=eps) {
        // Card cut, triangular
        up(raise/2+margin/2) cuboid(creditcard_real + [-margin, margin/2, raise/2-margin], chamfer=raise/2, edges=[LEFT+BOTTOM, RIGHT+BOTTOM, BACK+BOTTOM]);
    }
    align(FRONT, inside=true, shiftout=eps) fingerhole(30);
}

diff("remove", "keep") color_tag(1, "", "", "remove") {
    creditbox() {
        credit_hole(0);
        xcopies(hole_sep, 2) {
            $fn = 70;
            // Screw you
            align(BOTTOM) zcyl(d=hole_d, h=ring_h);
        }
        color_tag(2, "remove", "keep", undef) align(TOP, inside=true, shiftout=eps) zrot(180) logo(text_indent);
        // Tape indent
        align(BOTTOM, inside=true, shiftout=eps) cuboid(tape_indent, rounding=tape_rounding, edges="Z", $fn=30);
    }

}

module logo(h) {
    size = [100, 100, h];
    attachable(cp=size/2, size=size) {
        linear_extrude(h) import("assets/moppepay.svg");
        children();
    }
}

module fingerhole(h) {
    bez = [[-finger_w/2, 0], // pt
           [-finger_w/2+finger_curve, 0], // cp
           [-finger_curve, finger_h], // cp
           [0, finger_h], // pt
           [finger_curve, finger_h], // cp
           [finger_w/2-finger_curve, 0], // cp
           [finger_w/2, 0], // pt
           ];
    pts = bezpath_curve(bez, splinesteps=50);
    linear_sweep(pts, h=h) children();
}
