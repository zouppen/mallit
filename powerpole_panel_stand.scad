// Powerpole fuse box vertical holder
include <BOSL2/std.scad>

flap = [10, 2, 58.6];
wall = 2;
front_wedge = 25;
screw_hole_d = 6;
screw_d = 2;
screw_pos_y = 6;
screw_pos_z = 5;
over_flap = 15;
cham = 1;
$fn=32;

module part() {
    cuboid(flap + [wall, 2*wall, wall], chamfer=cham, edges=[TOP+RIGHT, TOP+BACK, TOP+FWD]) {
        align(BOTTOM+LEFT , inside=true) cuboid(flap);
        position(FWD+BOTTOM) wedge([$parent_size[0], front_wedge, $parent_size[2]-cham], spin=180, anchor=BOTTOM+FWD) {
            fwd(screw_pos_y) position(BACK+BOTTOM) tag("remove") {
                up(screw_pos_z) cyl(h=$parent_size[2]-screw_pos_z, d=screw_hole_d, chamfer1=(screw_hole_d-screw_d)/2, anchor=BOTTOM);
                cyl(h=screw_pos_z, d=screw_d, anchor=BOTTOM);
            }
        }
        position(BOTTOM+BACK) cuboid([$parent_size[0],wall,over_flap], anchor=TOP+BACK) {
            align(BACK, inside=true) ycyl(d2=screw_hole_d, d1=screw_d, h=(screw_hole_d-screw_d)/2);
        }
    }
}

diff() {
    xflip_copy(offset=flap[0]) part();
}
