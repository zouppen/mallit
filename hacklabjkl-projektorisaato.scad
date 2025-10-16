include <BOSL2/std.scad>

// This causes segment angle normals to be no more than 1° apart as
// long as the segment length is at least 0.2.
$fa=1;
$fs=0.2;
$align_msg = false;

nut_d = 13;
nut_h = 6.7;
bolt_d = 8;
thing_h = 60;
thing_d = 30;
nut_adj = 15;

cyl_d = nut_d/cos(180/6);

diff() {
    tag("remove") {
        up(nut_adj) hull() for (pos = [-20, 20]) {
            left(pos) cyl(d=cyl_d, h=nut_h, $fn=6);
        }
        cyl(h=thing_h+1, d=bolt_d);
    }
    zrot(180/6) cyl(h=thing_h, d=thing_d, $fn=6);
}
