// Weidmüller WDU 4 "sticker platforms"
//
// Useful for Dymo or other sticker printer to make smooth surface
// where to attach the marker stickers.
//
// To make platforms for different WDU models, change edge and
// mod_width constants accordingly.
include <BOSL2/std.scad>


bar_d1 = 34.6;
bar_d2 = 34.6;
bar_l = 60;
lamp_d = 30.3;
lamp_l = 67.7;
lamp_z = 71;
lamp_angle = -30;
wall = 2.7;
button_groove_w = 6;
button_groove_h = 1.2;
button_groove_start = 9;
ziptie_h = 2;
ziptie_w = 5;
ziptie_pos = [8, bar_l-8];

// This causes segment angle normals to be no more than 1° apart as
// long as the segment length is at least 0.2.
$fa=1;
$fs=0.2;
$align_msg = false;

module lamp_hole(extra=0) {
    real_d = 2*extra+lamp_d;
    back(abs(0.5*real_d*sin(lamp_angle))) down(lamp_z) xrot(lamp_angle) ycyl(d=real_d, h=lamp_l+extra, anchor=BACK, rounding1=extra) {
        children();
    }
}

module ziptie_ring() {
    r1 = bar_d1/2+wall+ziptie_h;
    r2 = bar_d2/2+wall+ziptie_h;
    tag("intersect") {
        rect_tube(size1=2*r1, size2=2*r2, h=bar_l, orient=BACK, anchor=TOP, wall=ziptie_h, rounding1=[0,r1,0,0], rounding2=[0,r2,0,0]);
    }
}

module ziptie_slices() {
    tag_intersect("remove") {
        ziptie_ring();
        for (pos = ziptie_pos) {
            fwd(pos) cuboid([200, ziptie_w, 200]);
        }
    }
}

module bicycle_bar(extra_len=0) {
    ycyl(d1=bar_d1, d2=bar_d2, h=bar_l, anchor=BACK, extra=extra_len);
}

diff() {
    hull() {
        front_half(s=500) lamp_hole(wall);
        bottom_half(s=500) bicycle_bar();
    }
    tag("remove") {
        bicycle_bar(10);
        lamp_hole() {
            attach(BOTTOM) back(1+button_groove_start) cuboid([button_groove_w,$parent_size[1]+2,2*button_groove_h], chamfer=0.5, edges=TOP);
        }
    }

    ziptie_slices();
}
