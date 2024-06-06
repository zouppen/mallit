include <BOSL2/std.scad>
include <BOSL2/screws.scad>

cap_sep = [34.5, 35];
cap_d = 33.7;
cap_h = 65; // Real is 64
cap_move = (2.3-16.2)/2;
pcb = [86.2, 121.4, 1.8];
pcb_bot_room = 5;
wall = 2;
screw_pos_left = [3.05+2.5,-35.1-2.5];
screw_pos_right = [-2.1-2.5,-30.7-2.5];
screw_type = "M5,11";
screw_fn = 60;
cap_fn = 200;
//screw_fn = 10;
//cap_fn = 10;
tol = 0.2;
shaft_h = 10;
shaft_skew_h = 30;
pole_screw_y = 7.5;
pole_screw_sep = 35.5;
pole_displace = (23-22.4)/2;
conn_room = 28;
safe_angle = 50; // Print no steeper cliffs

pp_align_displace = 0.2;
pp_hole = [60, 16.5, 15];
pp_real_h = 8.2;
pp_align_d = 2.1;
pp_align_pos = 10;
pp_pole_h = 11;

ovp = [29, 26.4, 20];
ovp_bot = 5;
ovp_cham = 3.5;
ovp_pcb = 1.2;

wireroom = [35, conn_room, ovp[2]+ovp_bot];
wireroom_x = 5;

echo(wall+cap_h-11);

module top_part() {
    cuboid(pcb + [2*wall, 2*wall+conn_room, cap_h+pcb_bot_room+1.5*wall], edges=["Z"], chamfer=1, anchor=BOTTOM) {
        // Top rounding
        edge_profile(TOP) mask2d_chamfer(5);

        // PCB
        fwd(wall) align(BOTTOM+BACK, inside=true) cuboid(pcb + [0, 0, 0.5*wall+pcb_bot_room]) {
            // Capacitors
            down(tol) fwd(cap_move) align(TOP) {
                grid_copies(cap_sep, [2,3]) cyl(d=cap_d, h=cap_h+tol, $fn=cap_fn);

                // Cut inner capacitor "pillars" to speed up printing
                cut = [cap_sep[0], 2*cap_sep[1]];
                room_h = cap_h+tol-shaft_h;
                fix = 2*room_h*tan(safe_angle);
                cube([cut[0], cut[1], shaft_h]) {
                    align(TOP) tag_intersect("remove") {
                        tag("intersect") prismoid(size1=cut, size2=cut+[fix, fix], h=room_h) {
                            // The rectangular part
                            back(cap_move-conn_room/2) tag("body") align(TOP, inside=true) cuboid([pcb[0], pcb[1]+conn_room, room_h], chamfer=wall, edges=TOP);
                        }
                    }
                }
            }

            // Self made holes
            for (pos = [[LEFT, screw_pos_left], [RIGHT, screw_pos_right]]) {
                position(BACK+TOP+pos[0]) move(pos[1]) screw_hole(screw_type, thread=true, oversize=tol, anchor=BOTTOM, $fn=screw_fn);
            }

            // Negative and positive poles
            right(pole_displace) for (pos = [-pole_screw_sep/2, pole_screw_sep/2]) {
                position(FWD+TOP) move([pos, pole_screw_y]) screw_hole(screw_type, thread=true, oversize=tol, anchor=BOTTOM, $fn=screw_fn);
            }

        }

        // Bottom cover opening
        align(BOTTOM, inside=true) cuboid([pcb[0]+wall, pcb[1]+wall+conn_room, 0.5*wall]);

        // Powerpole
        back(wall+conn_room/2-pp_hole[1]/2) align(LEFT+BOTTOM+FRONT, inside=true) tag_scope() diff("remove") {
            cuboid(pp_hole+[0,0,wall/2]) {
                //tag("remove") back(pp_align_displace) right(pp_align_pos) position(TOP+LEFT) cyl(d=pp_align_d, h=pp_pole_h, anchor=TOP, $fn=20);
                // Overengineer
                tag("remove") align(LEFT+FRONT, inside=true) cuboid([wall, pp_align_displace, $parent_size[2]], chamfer=pp_align_displace, edges=[RIGHT+BACK]);
            }
        }

        up(wall/2) {
            // Overvoltage protection PCB
            move([-wall,wall]) align(BOTTOM+FRONT+RIGHT, inside=true) cube([ovp[0], ovp[1], ovp_bot]) {
                align(TOP) cuboid(ovp, chamfer=ovp_cham, edges="Z");
            }

            // Room for wiring
            left(wireroom_x) back(wall) align(BOTTOM+FRONT, inside=true) cube(wireroom);

            // Extra cut to make wiring easier
            tag("remove") move([-wall-ovp[0], wall+ovp[1]+2]) position(BOTTOM+RIGHT+FRONT) cube([7, 7, pcb_bot_room], anchor=BACK+RIGHT+BOTTOM);
            // Extra extra cut
            tag("remove") move([-wall-ovp[0], wall+ovp[1]]) position(BOTTOM+RIGHT+FRONT) cuboid(pcb_bot_room, anchor=FRONT+LEFT+BOTTOM, chamfer=pcb_bot_room, edges=[FRONT+RIGHT]);

        }

        // Feet
        position(FRONT+LEFT+BOTTOM) foot(BACK+LEFT+BOTTOM, 0);
        position(FRONT+RIGHT+BOTTOM) foot(BACK+RIGHT+BOTTOM, 0);
        position(BACK+LEFT+BOTTOM) foot(BACK+RIGHT+BOTTOM, 180);
        position(BACK+RIGHT+BOTTOM) foot(BACK+LEFT+BOTTOM, 180);
    }
}

module foot(anchor, spin) {
    plateau_w = 10;
    screw_up = 7;
    screw_down = 4;

    cuboid(plateau_w, chamfer=wall, edges=[FRONT+LEFT, FRONT+RIGHT], anchor=anchor, spin=spin) {
        edge_profile(TOP+FRONT) mask2d_chamfer(sqrt(2)*plateau_w);
        align(TOP, inside=true) cyl(d=screw_up, h=plateau_w-wall, $fn=20) {
            align(BOTTOM) cyl(d2=screw_up, d1=screw_down, h=wall, $fn=20);
        }
        position(BACK+BOTTOM) cuboid([plateau_w, wall, plateau_w+wall], anchor=FRONT+BOTTOM, chamfer=wall, edges=[TOP+FRONT]);
        children();
    }
}

module bottom_part() {
    nudge = wall/2-tol;
    cuboid([pcb[0]+2*nudge, pcb[1]+2*nudge+conn_room, nudge], anchor=BOTTOM) {
        // OVP support
        align(TOP+RIGHT+FRONT) move([-wall/2, wall/2]) {
            tag_diff("nudge_sup") {
                cube([ovp[0]-2*tol, ovp[1]-2*tol, ovp_bot-ovp_pcb]);
                tag("remove") cuboid([ovp[0]-2*tol, ovp[1]-2*tol, ovp_bot-ovp_pcb], chamfer=ovp_cham-2*tol, edges=["Z"]);
            }
        }

        // Powerpole support
        down(nudge) left(nudge) back(wall/2 + conn_room/2-pp_hole[1]/2) align(TOP+LEFT+FRONT) {
            pp_real_l = ($parent_size[0]-wireroom[0])/2-wireroom_x;
            cube([pp_real_l, pp_hole[1], pp_hole[2]-pp_real_h+wall/2]) {
                // Overengineer II
                tag("remove") align(LEFT+FRONT, inside=true) cuboid([wall, pp_align_displace, $parent_size[2]], chamfer=pp_align_displace, edges=[RIGHT+BACK]);

                // Tap
                back(pp_align_displace) fwd(pp_align_displace) right(pp_align_pos-0.4) position(TOP+LEFT) cyl(d=pp_align_d, h=pp_real_h-tol, anchor=BOTTOM, $fn=20);
            }
        }
    }

}

diff() {
    top_part();
}

diff() {
    down(20) bottom_part();
}
