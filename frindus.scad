// Frindus vending machine part

include <BOSL2/std.scad>

// This causes segment angle normals to be no more than 1° apart as
// long as the segment length is at least 0.2.
$fa=1;
$fs=0.2;
$align_msg = false;

base = [26, 12, 12];
base_cham = 0.4;
hole_d = 4.3;
hole_adjust = [0, 0, 0.2];
eps = 0.2;
ring_d = 11;
ring_h = 9.8;
star_h = 25.8;
star_w = 6.5;
star_inner_d = 3;
star_inner_h = 10;
star_rounding = 0.4;
hole_fn = 6;

diff() {
    cuboid(base, chamfer=(base[1]-ring_d)/2, edges=TOP) {
        // Hole for tap
        tag("remove") move(hole_adjust) xcyl(d=hole_d/sin((hole_fn-2)*90/hole_fn), h=$parent_size[0]+eps, $fn=hole_fn);

        // Base ring
        align(TOP) zcyl(d=ring_d, h=ring_h, chamfer2=base_cham) {
            // Star thingy
            align(TOP) for (r = [0, 45]) {
                zrot(r) cuboid([star_w, star_w, star_h], rounding=star_rounding, edges=[TOP, "Z"]) {
                    // Hole
                    align(TOP, inside=true, shiftout=eps) {
                        zcyl(d=star_inner_d, h=star_inner_h);
                    }
                }
            }
        }
    }
}
