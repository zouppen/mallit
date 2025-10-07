include <BOSL2/std.scad>

// This causes segment angle normals to be no more than 1° apart as
// long as the segment length is at least 0.2.
$fa=1;
$fs=0.2;
$align_msg = false;

hand_w = 4;
disc_d = 89.5;
disc_thin = 1.4;

thin_w = 3.3; // width of thinnig, ~1/8 inch
thru_deg = 17; // through-the plate
thin_deg = 46; // thin part degrees
openings_deg = 60; // degrees between openings

cyl_d = 63;
cyl_h = 17;
cyl_wall = 2;

cut_width = 10;

module guide() {
    d_large = disc_d+1;
    align(BOTTOM, inside=true) pie_slice(h=hand_w-disc_thin, d=d_large, ang=thin_deg) {
        align(BOTTOM, inside=true) pie_slice(h=hand_w, d=d_large, ang=thru_deg, spin=thin_deg-thru_deg);
    }
}

module guides() {
    tag_scope() diff() tag("remove") cyl(h=hand_w, d=disc_d-thin_w*2) tag("") {
        zrot(thru_deg/2-thin_deg) for (angle=[0, openings_deg, 180, 180+openings_deg]) {
            zrot(angle) guide();
        }
    }
}

diff() {
    cyl(h = hand_w, d=disc_d, chamfer1=1) {
        position(BOTTOM) cyl(h=cyl_h, d=cyl_d, chamfer1=cyl_wall/2, anchor=TOP);
        tag("remove") cyl(h=100, d=cyl_d-2*cyl_wall);

        down(2) tag("remove") for (a = [0,90]) {
            zrot(a) cuboid([cut_width, 100, 100], anchor=TOP);
        }
    }

    force_tag("remove") guides();
}
