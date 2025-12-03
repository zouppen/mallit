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
screw_x = 10.5;
overhang = 32;
screw_top_d = 8;
screw_d = 4;
wall = 1.2;
wall_plus_tol = 1.5;
top_wall = 0.8;
slot_support_shrink = 0.5; // To avoid support to entangle with the object
support_ring = 2.5;

// Derived dimensions
outset = chime_h + cable_room - opening_h;
inset = chime_h - outset;
screw_sep = chime_d + 2*screw_x;
attach_fix = 90+77-slot_base_deg-slot_deg;

module virvel() {
    // Top part
    tube(h=outset, id=chime_d, od2=chime_d, od1=chime_d+overhang, anchor=BOTTOM) {
        position(TOP) tag("remove") xcopies(screw_sep) {
            // Top part
            cyl(h=outset-top_wall, d=screw_top_d, chamfer1=(screw_top_d-screw_d)/2, anchor=TOP);
            // Screw hole
            cyl(h=chime_h, d=screw_d, anchor=TOP);
        }
    }

    // Bottom part
    tube(h=inset, id=chime_d, wall=wall, anchor=TOP) {
        position(BOTTOM) tag_diff("vempele") {
            cyl(d=chime_d+2*wall, h=wall, anchor=TOP);
            for (a = slot_angles) {
                zrot(a+attach_fix) {
                    pie_slice(ang=slot_base_deg, l=slot_h, d=chime_d-2*wall_plus_tol, anchor=BOTTOM);
                    up(slot_h-slot_top_h) pie_slice(ang=slot_deg+slot_base_deg, l=slot_top_h, d=chime_d-2*wall_plus_tol, anchor=BOTTOM);
                    // And support ring
                    tag("keep") down(wall) pie_slice(ang=slot_deg+slot_base_deg, l=slot_h+wall, d=chime_d-2*slot_w, anchor=BOTTOM);
                    // Make inset to ease printing
                    tag("remove") up(0.1) zrot(slot_base_deg) pie_slice(ang=slot_deg, l=wall+0.2, d=chime_d-2*wall_plus_tol, anchor=TOP);
                }
            }
        }
        tag("remove") position(BOTTOM) cyl(h=10, d=chime_d-2*slot_w-2*wall);
    }
}

diff() virvel();

%diff() {
    // Bottom part
    up(1) tube(h=inset+wall+1, od=chime_d+overhang, wall=support_ring, anchor=TOP) {
        // Screw support
        xcopies(screw_sep) {
            cyl(h=$parent_size[2], d=chime_d+overhang-screw_sep);
        }

        // Support for the print inset
        position(BOTTOM) cyl(h=wall+slot_h, d=chime_d-2*wall_plus_tol-slot_support_shrink, anchor=BOTTOM);

        // Support for bridges
        cuboid([support_ring, $parent_size[1], $parent_size[2]]);
    }
}
