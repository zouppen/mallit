include <BOSL2/std.scad>

// BROKEN WITH RECENT VERSION OF BOSL2 (April 2024).
// TODO FIXME BUGBUG MELTDOWN THIS NEEDS REFACTOR!

screw_sep = [39, 71];
screw_hole_d = 3.6;
screw_safe_area = 2.5; // no component feet closer than this
pcb_rise = 3;
pcb_thickness = 1.6;
pcb_pos_y = 10.5;
inner_dim = [47, 120, 18];
wall = 2;

pp_hole = [16.1, 8];
pp_hole_pos_x = -11;
pp_rest = [4, 18, pcb_rise-0.6];
pp_align_d = 2.1;
pp_align_y = 10;

in_wire_hole = [5.5, 3.5];
in_wire_pos = [12.5, pcb_rise+pcb_thickness+3];

screw_stand = 9;
screw_stand_move = 1.55;
screw_inner_d = 2.5; // between threads
screw_upper_d = 7;
screw_outer_d = 3.5; // cover hole
screw_len = 15;

ziptie_w = 3;

tol = 0.2;
indent = wall/2+tol/2;

module feet() {
    fwd(pcb_pos_y) for(x = [-screw_sep[0]/2, screw_sep[0]/2]) {
        for(y = [-screw_sep[1]/2, screw_sep[1]/2]) {
            move([x,y]) {
                foot = screw_hole_d+2*screw_safe_area;
                cuboid([foot, foot, pcb_rise]) {
                    align(TOP, BOTTOM) cyl(d=screw_hole_d, h=pcb_thickness, $fn=20);
                }
            }
        }
    }
}

module feet_upper() {
    h = inner_dim[2] - pcb_rise - pcb_thickness - tol;
    foot = 7.2;
    fwd(pcb_pos_y) for(x = [-screw_sep[0]/2, screw_sep[0]/2]) {
        for(y = [-screw_sep[1]/2, screw_sep[1]/2]) {
            move([x,y]) {
                cuboid([foot, foot, h]);
            }
        }
    }
}
module bottom_part() {
    cuboid(inner_dim+[2*wall, 2*wall, wall], anchor=TOP) {
        align(TOP, inside=true) cuboid(inner_dim) {
            tag("keep") align(BOTTOM, inside=true) {
                feet();
            }
            // Powerpole hole
            up(pp_rest[2]) left(pp_hole_pos_x) position(BACK+BOTTOM) cuboid([pp_hole[0], wall, pp_hole[1]], anchor=BOTTOM+FWD) {
                tag("keep") {
                    tag_scope() diff() {
                        align(BOTTOM+BACK) cuboid(pp_rest);
                        tag("remove") fwd(pp_align_y) position(BOTTOM+BACK) cyl(d=pp_align_d+tol, h=pp_rest[2], anchor=TOP, $fn=20);
                    }
                }
            }

            // Wire input
            left(in_wire_pos[0]) up(in_wire_pos[1]) position(FWD+RIGHT+BOTTOM) cuboid([in_wire_hole[0], wall, in_wire_hole[1]], anchor=BACK) {
                // Ziptie fastener
                tag("keep") align(BOTTOM+FRONT) cuboid([$parent_size[0], 2*wall+ziptie_w, wall]) {
                    align(BOTTOM+BACK) cuboid([$parent_size[0], wall, in_wire_pos[1]-wall]);
                }
            }

            // Screw stands
            tag("keep") tag_scope() diff() {
                for(pos = [-1,1]) left(screw_stand_move*pos) position(BOTTOM+(BACK*pos)) cuboid([screw_stand, screw_stand, inner_dim[2]-indent+0.05], anchor=BOTTOM+(BACK*pos), chamfer=screw_stand/4, edges=[LEFT+FRONT*pos, RIGHT+FRONT*pos]) {
                        // Drill hole
                        tag("remove") position(TOP) cyl(d=screw_inner_d, h=screw_len, anchor=TOP, $fn=20);
                    }
            }
        }
        align(TOP, inside=true) cube([inner_dim[0]+2*indent, inner_dim[1]+2*indent, indent]);
    }
}

module top_part() {
    // Start with the cover
    cover_dim = [inner_dim[0]+2*wall, inner_dim[1]+2*wall, 0];
    cuboid(cover_dim+[0,0,wall], anchor=BOTTOM) {
        // Indent
        align(BOTTOM) cuboid(cover_dim + [-wall,-wall,wall/2]);

        // Feet
        align(BOTTOM) feet_upper();

        // Powerpole support
        wallpush = wall+tol;
        left(pp_hole_pos_x) fwd(wallpush) position(BACK+BOTTOM) cuboid([pp_rest[0], pp_rest[1]-wallpush, inner_dim[2]-pp_rest[2]-pp_hole[1]], anchor=TOP+BACK) {
            // Guiding pole
            fwd(pp_align_y-wallpush) position(BOTTOM+BACK) cyl(d=pp_align_d, h=pp_hole[1]+pp_rest[2]-tol, anchor=TOP, $fn=20);
        }

        // Screw holes
        tag("remove") for(pos = [-1,1]) left(screw_stand_move*pos) position(TOP+(BACK*pos)) {
                fwd(pos*(wall+screw_stand/2)) cyl(d2=screw_upper_d, d1=screw_outer_d, h=1.5*wall, anchor=TOP, $fn=20);
            }

        // Grill
        grill = [30, 1.5*wall, 1.5*wall+0.2];
        tag("remove") up(0.1) position(TOP) fwd(pcb_pos_y) ycopies(3*wall, 10) cuboid(grill, anchor=TOP);

        // Text
        tag("texts") recolor("red") {
            back(4) left(in_wire_pos[0]) position(FRONT+RIGHT+TOP) text3d("IN", h=0.4, size=5, anchor=CENTER+TOP);
            fwd(4) left(13.5) position(BACK+RIGHT+TOP) text3d("OUT", h=0.4, size=5, spin=180, anchor=CENTER+TOP);
        }
    }
}

module difftext(render_text) {
    if (render_text) {
        diff("remove runko", "texts") tag("runko") children();
    } else {
        diff("remove texts", "") children();
    }
}

want_texts = false;

difftext(want_texts) {
    up(20) top_part();
}

difftext(want_texts) {
    bottom_part();
}
