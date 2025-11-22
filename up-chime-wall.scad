// Wall mount for Ubiquiti PoE Smart Chime (UACC-Chime-PoE)

include <BOSL2/std.scad>

// This causes segment angle normals to be no more than 1° apart as
// long as the segment length is at least 0.2.
$fa=1;
$fs=0.2;
$align_msg = false;

// Dimensions
opening_h = 55;
chime_d = 62.3;
chime_h = 49;
cable_room = 20;
slot_h = 3;
slot_top_h = 1.2;
slot_deg = 25;
slot_base_deg = 5;
slot_w = 4.8; // Including wall
slot_angles = 77*[0,1,2,3];
chime_wall = 1.4;
ring_w = 7;
screw_x = 6;
overhang = 23;
screw_top_d = 9;
screw_d = 4;
wall = 1.2;
wall_plus_tol = 1.5;

// Derived dimensions
outset = chime_h + cable_room - opening_h;
inset = chime_h - outset;
screw_sep = chime_d + 2*screw_x;
top_wall = wall;

diff() {
    // Top part
    tube(h=outset, id=chime_d, od2=chime_d, od1=chime_d+overhang, anchor=BOTTOM) {
        position(TOP) tag("remove") xcopies(screw_sep) {
            cyl(h=outset-top_wall, d=screw_top_d, anchor=TOP);
            cyl(h=chime_h, d=screw_d, anchor=TOP);
        }
    }

    // Bottom part
    tube(h=inset, id=chime_d, wall=wall, anchor=TOP) {
        position(BOTTOM) tag_diff("vempele") {
            cyl(d=chime_d+2*wall, h=wall, anchor=TOP);
            for (a = slot_angles) {
                zrot(a) {
                    pie_slice(ang=slot_base_deg, l=slot_h, d=chime_d-2*wall_plus_tol, anchor=BOTTOM);
                    up(slot_h-slot_top_h) pie_slice(ang=slot_deg+slot_base_deg, l=slot_top_h, d=chime_d-2*wall_plus_tol, anchor=BOTTOM);
                    // And support ring
                    tag("keep") down(wall) pie_slice(ang=slot_deg+slot_base_deg, l=slot_h+wall, d=chime_d-2*slot_w, anchor=BOTTOM);
                    // Make printing easier
                    tag("remove") up(0.1) zrot(slot_base_deg) pie_slice(ang=slot_deg, l=wall+0.2, d=chime_d-2*wall_plus_tol, anchor=TOP);


                }
            }
        }
        tag("remove") position(BOTTOM) cyl(h=10, d=chime_d-2*slot_w-2*wall);
    }
}
