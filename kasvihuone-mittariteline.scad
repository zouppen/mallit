include <BOSL2/std.scad>
include <powerpole_lib.scad>

// The fan & base part

screw_dist = 105; // Fan screw distance
screw_d = 4.2; // Fan screw diameter for M4 with good clearance.
fan_d = 120; // Fan outer dimensions
fan_inner_d = 116; // Fan propeller diameter
plat_h = 3; // Flat part height on the top
base_h = 180; // Feet part height
base_bot_d = 180; // Feet part width
base_z_round = 4; // This is the same as the fan rounding
finish_trim = 3; // Trim the openings a little to make them print better
base_ang = 15; // Feet part opening angle
screw_extra=5; // Screw base height. Adjust to hide extra screw length
screw_top=8.3; // Make the screw base and the driver to fit

// The hand attachment part, affects the base.

hand_w = 45; // Flat part of Shelly H&T width
hand_outset = 5.5; // Shelly hand base thickness
hand_round = 5; // Just for the looks
hand_hole_sep = 30; // Distance between screws in the bottom end of the hand.
hand_z = 33; // Attachment point for the hand
hand_bottom_screw_pos = 5; // Perfect value depends on base_ang variable

// Hand related

hand_h = 3; // Shelly hand thickness
shelly_screw_x = -2.9; // Shelly H&T Gen3 screws are not in the middle!
headroom_fixed = 35 + 43; // Shelly + fan
headroom_extra = 70; // Shelly hand visible part

// Shelly related

shelly_hole_sep = 25; // Distance between screws in the Shelly end (top).
shelly_hole_d = 3.8; // Shelly screw hole diameter. Interference fit for M4 screw.
shelly_top = 25; // Shelly hand top extra (measured from the screws)

// PSU compartment

psu = [41, 15, 115]; // PSU compartment size
psu_ceil = 2; // PSU "ceiling" height
fan_wire_d = 4; // Size of extra openings near PP connector
small_wall = 1; // Thickness of the screw platform
tol = 0.4; // Clearance of the PSU box.

// VNF for base parts, useful for making the projection cut to ease 3D
// printing.
frame_base = prismoid(size2=[fan_d, fan_d], size1=[base_bot_d, base_bot_d], h=base_h, anchor=TOP, rounding=base_z_round, $fn=32);
frame_ring = cyl(d=fan_inner_d, h=plat_h, anchor=TOP, extra2=0.1, $fn=256);
frame_cut = cyl(d2=fan_inner_d, d1=fan_inner_d+tan(base_ang)*2*base_h, h=base_h, anchor=TOP, extra2=0.1, $fn=256);

module finisher() {
    xrot(-90) linear_extrude(base_bot_d, center=true) offset(r=finish_trim, $fn=10) intersect() {
        tag("intersect") rect([0.65*base_bot_d,base_h], anchor=DOWN);
        projection() xrot(90) tag_scope() diff() {
            tag("remove") vnf_polyhedron(frame_base);
            vnf_polyhedron(frame_ring) position(BOTTOM) vnf_polyhedron(frame_cut);
        }
    }
}

diff() {
    vnf_polyhedron(frame_base) {
        // Shelly raiser
        position(TOP+BACK) cuboid([hand_w, hand_outset, hand_z], anchor=TOP+FWD, rounding=hand_round, edges=[BOTTOM+LEFT, BOTTOM+RIGHT]) {
            tag("remove") xcopies(hand_hole_sep) position(BACK) ycyl(d=screw_d, h=hand_bottom_screw_pos, anchor=BACK, extra2=50, $fn=32) {
                position(FWD) ycyl(d1=screw_top, d2=screw_d, h=(screw_top-screw_d)/2, extra1=10, anchor=FWD);
            }

            // Hand
            back(10) position(BACK+BOTTOM) cuboid([$parent_size[0], hand_h, $parent_size[2]+headroom_fixed+headroom_extra], anchor=FWD+BOTTOM, edges="Y", rounding=hand_round, $fn=32) {
                // And the screw holes
                tag("remove") right(shelly_screw_x) down(shelly_top) position(TOP+FWD) xcopies(shelly_hole_sep) ycyl(d=shelly_hole_d, h=$parent_size[1]+psu[1], anchor=FWD);

                // PSU slot
                up(hand_z) position(BACK+BOTTOM) cuboid([$parent_size[0], psu[1]+psu_ceil, $parent_size[2]-hand_z], anchor=FRONT+BOTTOM, rounding=hand_round, edges=[TOP+LEFT, TOP+RIGHT]) {
                    tag("remove") down(0.01) position(FRONT+BOTTOM) cuboid(psu, anchor=FRONT+BOTTOM);
                };

                // Powerpole connector
                back(25) {
                    // Screwed part
                    position(BOTTOM+BACK) up(hand_z/2-screw_d) cuboid([psu[0]-tol,small_wall,hand_z/2+screw_d+0.1], edges=[BOTTOM+LEFT, BOTTOM+RIGHT], rounding=screw_d/2, anchor=FRONT+BOTTOM);
                    // Block
                    position(BOTTOM+BACK) up(hand_z) cuboid([psu[0]-tol,psu[1]-tol,powerpole_h], anchor=FRONT+BOTTOM) {
                        back(0.2) tag("remove") xrot(180) position(TOP) powerpole_slot();
                        // Room for fan wires
                        tag("remove") for (side=[LEFT,RIGHT]) position(side) zcyl(h=$parent_size[2], d=fan_wire_d, extra=1, $fn=6, spin=180/6);
                    }
                }
            }
        }

        // Screw holes on top
        tag("remove") position(TOP) grid_copies(n=[2,2], spacing=screw_dist) {
            cyl(d=screw_d, h=screw_extra, extra2=1, anchor=TOP, $fn=48) {
                position(BOTTOM) cyl(d1=screw_top, d2=screw_d, h=(screw_top-screw_d)/2, extra1=100, anchor=TOP);
            }
        }

    }
    // Clean area
    tag("remove") vnf_polyhedron(frame_ring) {
        position(BOTTOM) vnf_polyhedron(frame_cut);
    }
    tag("remove") zrot_copies(rots=[0,90]) finisher();
}
