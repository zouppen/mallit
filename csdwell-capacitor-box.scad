include <BOSL2/std.scad>
include <BOSL2/screws.scad>

cap_sep = [34.5, 35];
cap_d = 33.7;
cap_h = 65; // Real is 64
cap_move = (2.3-16.2)/2;
pcb = [86.2, 121.4, 1.8];
pcb_bot_room = 3;
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
pole_screw_sep = 34.5;
safe_angle = 45; // Print no steeper cliffs
conn_room = 20;

echo(wall+cap_h-11);

diff() {
    cuboid(pcb + [2*wall, 2*wall+conn_room, cap_h+pcb_bot_room+1.5*wall], edges=["Z", TOP], chamfer=1) {
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
            for (pos = [-pole_screw_sep/2, pole_screw_sep/2]) {
                position(FWD+TOP) move([pos, pole_screw_y]) screw_hole(screw_type, thread=true, oversize=tol, anchor=BOTTOM, $fn=screw_fn);
            }

        }
        // Bottom cover opening
        align(BOTTOM, inside=true) cuboid([pcb[0]+wall, pcb[1]+wall+conn_room, 0.5*wall]);
    }
}
