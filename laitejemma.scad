include <BOSL2/std.scad>

box = [110,65,85];
box_chamfer=2;
cutsize = 6; // How tall is the cut
cut_z = box[2]-cutsize-box_chamfer; // where the cut is

// Device slots
device_a=[98.1, 10.1, 70.1];
device_a_pos = 16;
device_b=[62.5, 10.3, 18.4];
device_b_pos = -16;

// Finger slot
fingerslot_w = 6;
fingerslot_guide = 5;

// Cut configuration
cutaxis = [-90,0,0];
tol = 0.1;
cutpos = [0,-cut_z+tol-cutsize/2,0];
spread = 50; // separate or not

module slidebox() {
    rotate(-cutaxis) move(-cutpos) partition([box[0],200,200],spread=spread, gap=2, cutsize=cutsize, cutpath="dovetail", $slop=tol) move(cutpos) rotate(cutaxis) {
        diff() cuboid(box, chamfer=box_chamfer, anchor=BOTTOM) down(box_chamfer+2*tol) align(TOP, inside=true) {
            children();
        }
    }
}

module slot(size, slot_w) {
    cuboid(size + [0, 0, cutsize]);
    cuboid(size + [-fingerslot_guide*2, slot_w*2, cutsize*0]);
}

bottom_half(s=200, z=60) slidebox() {
    slot(device_a, 2);
    fwd(device_a_pos) slot(device_a, fingerslot_w);
    fwd(device_b_pos) slot(device_b, fingerslot_w);
}

top_half(s=200, z=60) slidebox();
