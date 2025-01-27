include <BOSL2/std.scad>

$align_msg=false;

hole_sep = 65;
hole_d = 8.3;
hole_inner_d = 6.9;
ring_h = 5;
screw_d = 4.2;
screw_wall = 1;

creditcard = [53.98, 85.6, 0.6];
creditbox = [90, 90, 6];
credit_margin = 0.2;
rounding = 10;

creditcard_real = add_scalar(creditcard, credit_margin);

fingerhole = 16;
text_indent = 0.4;
raise = 4.2;
eps = 0.02;

//$fn=100;

color=0;

module color_tag(my_color, zero, hit, miss, juku) {
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

diff("remove", "keep") hide("hidden") color_tag(1, "", "", "remove") {
    creditbox() {
        tag("remove") move([0,-eps,-eps]) align(FRONT+BOTTOM, inside=true) cuboid(creditcard_real + [0, 1, raise+eps], chamfer=raise+eps, edges=[LEFT+BOTTOM, RIGHT+BOTTOM, BACK+BOTTOM]);
        tag("remove") position(FRONT) zcyl(h=30, d=fingerhole, $fn=100);
        xcopies(hole_sep, 2) {
            $fn = 70;
            // Screw you
            color_tag(2, "", "", undef) align(BOTTOM) zcyl(d=hole_d, h=ring_h);
            // Cut screw opening
            tag("remove") cyl(30, d=hole_inner_d);
        }
        color_tag(2, "remove", "keep", undef, "juku") align(TOP, inside=true) zrot(180) zfight(up(eps)) logo(text_indent);
    }

}

module zfight(tr) {
    multmatrix($preview ? tr : IDENT) children();
}

module logo(h) {
    size = [90, 90, h];
    attachable(cp=size/2, size=size) {
        linear_extrude(h) import("assets/moppepay.svg");
        children();
    }
}
