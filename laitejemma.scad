include <BOSL2/std.scad>

box = [110,65,85];
box_chamfer=2;
cutsize = 6; // How tall is the cut
cut_z = box[2]-cutsize-box_chamfer; // where the cut is
slot_extra = 1; // How much extra on y axis for the slots
slot_extra_bottom = 1;

// Device slots
device_a=[98.1, 10.1, 70];
device_a_pos = 16;
device_b=[62.5, 10.4, 18.4];
device_b_pos = -16;

// Finger slot
fingerslot_wall_keepout = 2;
fingerslot_d = 15;
slot_guide = 7; // How long support for the devices

// Cut configuration
cutaxis = [-90,0,0];
tol = 0.1;
cutpos = [0,-cut_z+tol-cutsize/2,0];
spread = 50; // separate or not

module slidebox() {
    rotate(-cutaxis) move(-cutpos) partition([box[0],200,200],spread=spread, gap=2, cutsize=cutsize, cutpath="dovetail", $slop=tol) move(cutpos) rotate(cutaxis) {
        diff() cuboid(box, chamfer=box_chamfer, anchor=BOTTOM) down(box_chamfer+2*tol) align(TOP, inside=true) {
            if ($partition_part == SECOND) {
                children();
            }
        }
    }
}

module slot(size) {
    cuboid(size + [0, 0, cutsize]);
    cuboid(size + [-2*slot_guide, 2*slot_extra, cutsize], chamfer=slot_extra, edges=["Z",BOTTOM+FWD, BOTTOM+BACK]);
    cuboid(size + [-2*slot_guide, 0, cutsize+slot_extra_bottom], chamfer=slot_extra_bottom, edges=BOTTOM);

}

slidebox() {
    slot(device_a);
    fwd(device_a_pos) slot(device_a);
    fwd(device_b_pos) slot(device_b);
    up(cutsize) cuboid([fingerslot_d, box[1]-2*fingerslot_wall_keepout, fingerslot_d+cutsize], chamfer=fingerslot_d/4, edges=[BOTTOM,"Z"]);
}
