include <BOSL2/std.scad>
include <powerpole_lib.scad>

screw_dist = 105;
screw_d = 4.2;
fan_d = 120; // Fan outer dimensions
fan_inner_d = 116; // Fan propeller diameter
plat_h = 3; // Flat part height on the top
base_h = 180; // Feet part height
base_bot_d = 180; // Feet part width
base_z_round = 4; // This is the same as the fan rounding
finish_trim = 3; // Trim the openings a little to make them print better

ang = 15; // Feet part opening angle
shelly_back_w = 45; // Flat part of Shelly H&T width
shelly_outset = 5.5; // Shelly hand base thickness
shelly_round = 5; // Just for the looks
shelly_hole_sep = 25; // Distance between screws in the back
shelly_hole_d = 2.4; // Shelly helper hole diameter for the screw
shelly_hand_z = 33; // Attachment point for the hand

screw_extra=5; // Screw base height
screw_top=8.3; // Make the screw base and the driver to fit

shelly_hand_bottom_screw_pos = 3; // Perfect fit depends on ang variable
shelly_hand_w = 3; // Shelly hand thickness
shelly_top = 25; // Shelly hand top extra
shelly_screw_x = -2.9; // Shelly H&T Gen3 screws are not in the middle!
headroom_fixed = 35 + 43; // Shelly + fan
headroom_extra = 70; // Shelly hand visible part

psu = [26.6, 14.2, 100];
psu_wall = 2;
fan_wire_d = 4;
tol = 0.4;

// VNF for base parts, useful for making the projection cut to ease 3D
// printing.
frame_base = prismoid(size2=[fan_d, fan_d], size1=[base_bot_d, base_bot_d], h=base_h, anchor=TOP, rounding=base_z_round, $fn=32);
frame_ring = cyl(d=fan_inner_d, h=plat_h, anchor=TOP, extra2=0.1, $fn=256);
frame_cut = cyl(d2=fan_inner_d, d1=fan_inner_d+tan(ang)*2*base_h, h=base_h, anchor=TOP, extra2=0.1, $fn=256);

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
        position(TOP+BACK) cuboid([shelly_back_w, shelly_outset, shelly_hand_z], anchor=TOP+FWD, rounding=shelly_round, edges=[BOTTOM+LEFT, BOTTOM+RIGHT]) {
            tag("remove") xcopies(shelly_hole_sep) position(BACK) ycyl(d=screw_d, h=shelly_hand_bottom_screw_pos, anchor=BACK, extra2=50, $fn=32) {
                position(FWD) ycyl(d1=screw_top, d2=screw_d, h=(screw_top-screw_d)/2, extra1=10, anchor=FWD);
            }

            // Hand
            back(10) position(BACK+BOTTOM) cuboid([$parent_size[0], shelly_hand_w, $parent_size[2]+headroom_fixed+headroom_extra], anchor=FWD+BOTTOM, edges="Y", rounding=shelly_round, $fn=32) {
                // And the screw holes
                tag("remove") right(shelly_screw_x) down(shelly_top) position(TOP) xcopies(shelly_hole_sep) ycyl(d=shelly_hole_d, h=$parent_size[1]+1);

                // PSU slot
                box = psu + [2*psu_wall, psu_wall, psu_wall];
                up(shelly_hand_z) position(BACK+BOTTOM) cuboid(box, anchor=FRONT+BOTTOM) {
                    tag("reuna") edge_profile_asym([FRONT+LEFT, FRONT+RIGHT, FRONT+TOP], corner_type="chamfer", flip=true)
                        xflip() mask2d_chamfer(sqrt(2)*psu_wall);
                    edge_profile_asym(BACK, corner_type="chamfer")
                        mask2d_chamfer(sqrt(2)*psu_wall);
                    tag("remove") down(0.01) position(FRONT+BOTTOM) cuboid(psu, anchor=FRONT+BOTTOM);
                };

                // Powerpole connector
                small_wall = 1;
                back(25) {
                    // Screwed part
                    position(BOTTOM+BACK) up(shelly_hand_z/2) cuboid([shelly_hole_sep+2*screw_d,small_wall,screw_d*2], edges="Y", rounding=screw_d/2, anchor=FRONT);
                    // Guide. Extending 1 mm on both sides to avoid tiny
                    // gaps which mess PrusaSlicer.
                    position(BOTTOM+BACK) up(shelly_hand_z/2+screw_d-1) cuboid([psu[0]-tol,small_wall,shelly_hand_z/2-screw_d+2], anchor=FRONT+BOTTOM);

                    // Block
                    position(BOTTOM+BACK) up(shelly_hand_z) cuboid([psu[0]-tol,psu[1]-tol,powerpole_h], anchor=FRONT+BOTTOM) {
                        back(0.2) tag("remove") xrot(180) position(TOP) powerpole_slot();
                        tag("remove") position(LEFT) zcyl(h=$parent_size[2], d=fan_wire_d, extra=1);
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
