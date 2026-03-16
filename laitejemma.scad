include <BOSL2/std.scad>
include <BOSL2/structs.scad>

$no_top=false;

box_chamfer=2;
cutsize = 4; // How tall is the cut
cut_z = box[2]-cutsize-box_chamfer; // where the cut is
slot_extra = 1; // How much extra on y axis for the slots
slot_extra_bottom = 1;

// Lock rod
lock_rod = [box[0],4,2];
lock_rod_handle = 4;

// Finger slot
fingerslot_wall_keepout = 5;
fingerslot_d = 16;
slot_guide = 7; // How long support for the devices on the bottom (on x axis)

// Cut configuration
cutaxis = [-90,0,0];
tol = 0.1;
cutpos = [0,-cut_z+tol-cutsize/2,0];
spread = 50; // separate or not

module skipper() {
    if ($idx == 1 || !$no_top) children();
}

module slidebox(lock_rod_y) {
    rotate(-cutaxis) move(-cutpos) partition([500,500,500],spread=spread, gap=2, cutsize=cutsize, cutpath="jigsaw", $fn=24, $slop=0.1) skipper() move(cutpos) rotate(cutaxis) {
        diff() cuboid(box, chamfer=box_chamfer, anchor=BOTTOM) {
            if ($idx == 1) {
                down(box_chamfer+2*tol) children();
            }

            // Lock rod opening
            back(lock_rod_y) align(TOP+LEFT, inside=true) {
                // Rod hole
                down(box_chamfer) cuboid(lock_rod);
                // Rod insert
                cuboid([lock_rod_handle, lock_rod[1], box_chamfer]);
            }

            // Lock rod
            up(2*spread) align(TOP+LEFT, inside=true) tag("") {
                cuboid([lock_rod_handle-1-tol, lock_rod[1]-tol, box_chamfer+lock_rod[2]-tol], chamfer=box_chamfer, edges=[TOP+LEFT]) {
                    position(BOTTOM+LEFT) {
                        // Long part
                        cuboid(lock_rod-[tol,tol,3*tol], anchor=BOTTOM+LEFT);
                    }
                }
            }

        }
    }
}

module slot(hole_size, hole_pos=[], extra) {
    // Move things up by one so that cut has no z fighting
    pos = list_pad(hole_pos, 3, 0) + [0,0,1];
    size = hole_size + [0, 0, cutsize+1];
    move(pos) {
        if (extra) {
            cuboid(size) {
                children();
            }
            cuboid(size + [-2*slot_guide, 2*slot_extra, 0], chamfer=slot_extra, edges=["Z",BOTTOM+FWD, BOTTOM+BACK]);
            cuboid(size + [-2*slot_guide, 0, slot_extra_bottom], chamfer=slot_extra_bottom, edges=BOTTOM);
        } else {
            cuboid(size, chamfer=slot_extra_bottom, edges=["Z", BOTTOM]) {
                children();
            }
        }
    }
}

module render_box(lock_rod_y = 0) {
    slidebox(lock_rod_y) {
        // Opportunity to attach something to the case
        $name = "chassis";
        children();
        align(TOP, inside=true) for (raw = slots) {
            // Making a struct of it
            s = struct_set([], raw);
            $name = struct_val(s, "name");
            slot(struct_val(s, "size"), struct_val(s, "pos", []), struct_val(s, "extra", true)) {
                children();
            }
        }

        // Fingerslots
        align(TOP, inside=true) for (slot_pos = fingerslots) {
            right(slot_pos) up(cutsize) cuboid([fingerslot_d, box[1]-2*fingerslot_wall_keepout, fingerslot_d+cutsize], chamfer=fingerslot_d/4, edges=[BOTTOM,"Z"]);
        }
    }
}
