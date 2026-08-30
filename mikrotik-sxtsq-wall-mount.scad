include <BOSL2/std.scad>

bar_d = 30;
bar_w = 14;
hand_w = 44;
hand_l = 70;
gap = 7;
chamfer = 2;
angle = 10;
mount_w = 90;
mount_hole_d = 4.2;
mount_hole_sep = 72;
mount_thickness = 4;
eps=0.1;

// This causes segment angle normals to be no more than 1° apart as
// long as the segment length is at least 0.2.
$fa=1;
$fs=0.2;
$align_msg = false;

// Hand
front_half(s=2*hand_l) zrot(angle) {
    // Mikrotik attachment point
    fwd(hand_l) {
        xcyl(h=hand_w, d=bar_d, anchor=FWD, chamfer=chamfer) {
            for (side=[LEFT, RIGHT]) {
                position(side) cuboid([(hand_w-bar_w)/2, gap+bar_d/2+chamfer, bar_d], anchor=FWD+side, chamfer=chamfer, edges="Y");
            }
        }
    }

    // Rest of the hand
    fwd(hand_l-bar_d-gap) cuboid([hand_w, hand_l, bar_d], anchor=FWD, chamfer=chamfer, edges=["Y", FWD+TOP, FWD+BOTTOM]);
}

// Mount
diff() {
    support_h = 28;
    cuboid([mount_w, mount_thickness, bar_d], anchor=FWD, rounding=bar_d/2, edges="Y") {
        tag("remove") xcopies(mount_hole_sep) ycyl(d=mount_hole_d, h=mount_thickness+eps);
        position(FRONT) prismoid([2.05*mount_hole_sep-mount_w, bar_d], [hand_w, bar_d], orient=FWD, anchor=BOTTOM, h=support_h, chamfer=chamfer, shift=[sin(angle)*support_h,0]);
    }
}
