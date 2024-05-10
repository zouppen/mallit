include <BOSL2/std.scad>

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
screw_inner_d = 2.5;
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
module case() {
    cuboid(inner_dim+[2*wall, 2*wall, wall]) {
        align(TOP, inside=true) cuboid(inner_dim) {
            tag("keep") align(BOTTOM, inside=true) {
                feet();
            }
            // Powerpole hole
            up(pp_rest[2]) left(pp_hole_pos_x) position(BACK+BOTTOM) cuboid([pp_hole[0], wall, pp_hole[1]], anchor=BOTTOM+FWD) {
                tag("keep") {
                    tag_scope() diff() {
                        align(BOTTOM+BACK) cuboid(pp_rest);
                        //fwd(pp_align_y) position(BOTTOM+BACK) cyl(d=pp_align_d, h=pp_hole[1], anchor=BOTTOM, $fn=20);
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


diff() {
    case();
}
