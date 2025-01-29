include <BOSL2/std.scad>

$align_msg=false;

ring_h = 3;
hole_sep = 65;
hole_d = 8.4;
hole_inner_d = 7.8;
hole_indent = ring_h-1.05;
hole_indent_bump = 0.4;
screw_d = 4.2;
screw_wall = 1;

creditcard = [85.6, 53.98, 0.6];
creditbox = [100, 65, 6];
credit_margin = 0.4;
rounding = 10;

creditcard_real = add_scalar(creditcard, credit_margin);

fingerhole = 16;
text_indent = 0.4;
raise = 4.2;
eps = 0.02;

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
    tag("remove") move([0,-eps,-eps]) align(FRONT+BOTTOM, inside=true) {
        // Card cut, triangular
        up(raise/2+margin/2) cuboid(creditcard_real + [-margin, eps-margin/2, raise/2+eps-margin], chamfer=raise/2+eps, edges=[LEFT+BOTTOM, RIGHT+BOTTOM, BACK+BOTTOM]);
    }
    tag("remove") position(FRONT) zcyl(h=30, d=fingerhole-margin, $fn=100);
}

/*
!intersect() {
    tag("intersect") creditbox() {
        credit_hole(0.2);
        tag("keep") align(FRONT+BOTTOM) cube(5);
    }
}
*/

diff("remove", "keep") hide("hidden") color_tag(1, "", "", "remove") {
    creditbox() {
        credit_hole(0);
        xcopies(hole_sep, 2) {
            $fn = 70;
            // Screw you
            color_tag(1, "", "", undef) align(BOTTOM) zcyl(d=hole_d, h=ring_h) {
                // Cut screw opening
                align(BOTTOM, inside=true) {
                    zfight(down(eps)) cyl(hole_indent+eps, d=hole_inner_d) {
                        // Add bumps
                        for (side = [0, 90, 180, 270]) {
                            tag("keep") {
                                zrot(side) fwd(hole_inner_d/2) cuboid([hole_indent_bump*2, hole_indent_bump, $parent_size[2]], anchor=FWD, chamfer = hole_indent_bump/3, edges=[BOTTOM+BACK, BACK+LEFT, BACK+RIGHT]);
                            }
                        }
                    }
                }
            }
        }
        color_tag(2, "remove", "keep", undef) align(TOP, inside=true) zrot(180) zfight(up(eps)) logo(text_indent);
    }

}

module zfight(tr) {
    multmatrix($preview ? tr : IDENT) children();
}

module logo(h) {
    size = [100, 100, h];
    attachable(cp=size/2, size=size) {
        linear_extrude(h) import("assets/moppepay.svg");
        children();
    }
}
